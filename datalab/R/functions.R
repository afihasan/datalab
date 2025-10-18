#' Resolve variable name to column in data
#'
#' @param var Bare variable name
#' @param data Data frame (defaults to finding any dataframe in environment)
#' @return Vector of values
#' @keywords internal
resolve_var <- function(var, data = NULL) {
  # Wrap in tryCatch to handle errors cleanly
  var_name <- tryCatch({
    rlang::as_name(rlang::ensym(var))
  }, error = function(e) {
    stop("Invalid variable specification. Use bare variable names without quotes (e.g., boxplot(age, group = sex)).", call. = FALSE)
  })
  
  if (is.null(data)) {
    # Find ANY data frame in parent environment
    parent_env <- parent.frame(2)
    all_objects <- ls(envir = parent_env)
    
    # Find all data frames
    dataframes <- Filter(function(obj_name) {
      obj <- get(obj_name, envir = parent_env)
      is.data.frame(obj)
    }, all_objects)
    
    if (length(dataframes) == 0) {
      stop("No data frame found in environment. Please provide 'data' argument or create a data frame.", call. = FALSE)
    }
    
    # Use the first data frame found (or prioritize 'data'/'df' if they exist)
    if ("data" %in% dataframes) {
      data <- get("data", envir = parent_env)
    } else if ("df" %in% dataframes) {
      data <- get("df", envir = parent_env)
    } else {
      data <- get(dataframes[1], envir = parent_env)
    }
  }
  
  if (!var_name %in% names(data)) {
    stop(sprintf("Variable '%s' not found in data. Check spelling or provide correct 'data' argument.", var_name), call. = FALSE)
  }
  
  data[[var_name]]
}

#' Create a line chart
#'
#' @param x Variable for x-axis (bare name)
#' @param y Variable for y-axis (bare name)
#' @param data Optional data frame (defaults to any dataframe in environment)
#' @param title Chart title
#' @param x_label X-axis label
#' @param y_label Y-axis label
#' @param smooth Add smooth line (default: FALSE)
#' @param group Optional grouping variable for multiple lines (bare name)
#' @return A ggplot object
#' @export
#' @examples
#' \dontrun{
#' mydata <- data.frame(time = 1:10, value = rnorm(10))
#' linechart(time, value)
#' }
linechart <- function(x, y, data = NULL, title = NULL, x_label = NULL, 
                      y_label = NULL, smooth = FALSE, group = NULL) {
  x_name <- rlang::as_name(rlang::ensym(x))
  y_name <- rlang::as_name(rlang::ensym(y))
  
  x_vals <- resolve_var(!!rlang::ensym(x), data)
  y_vals <- resolve_var(!!rlang::ensym(y), data)
  
  if (is.null(x_label)) x_label <- x_name
  if (is.null(y_label)) y_label <- y_name
  if (is.null(title)) title <- paste(y_name, "vs", x_name)
  
  plot_data <- data.frame(x = x_vals, y = y_vals)
  
  if (!is.null(group)) {
    group_name <- rlang::as_name(rlang::ensym(group))
    group_vals <- resolve_var(!!rlang::ensym(group), data)
    plot_data$group <- as.factor(group_vals)
    
    p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = x, y = y, color = group, group = group)) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_point(size = 2) +
      ggplot2::scale_color_brewer(palette = "Set1", name = group_name)
  } else {
    p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = x, y = y)) +
      ggplot2::geom_line(color = "#2E86AB", linewidth = 1) +
      ggplot2::geom_point(color = "#2E86AB", size = 2)
  }
  
  p <- p +
    ggplot2::labs(title = title, x = x_label, y = y_label) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
      panel.grid.minor = ggplot2::element_blank()
    )
  
  if (smooth) {
    p <- p + ggplot2::geom_smooth(method = "loess", se = TRUE, alpha = 0.2)
  }
  
  print(p)
  invisible(p)
}

#' Create a boxplot
#'
#' @param var Variable to plot (bare name)
#' @param data Optional data frame
#' @param group Optional grouping variable (bare name, no quotes needed)
#' @param title Chart title
#' @return A ggplot object
#' @export
#' @examples
#' \dontrun{
#' mydata <- data.frame(values = rnorm(100), category = sample(c("A","B"), 100, replace=TRUE))
#' boxplot(values)
#' boxplot(values, group = category)
#' }
boxplot <- function(var, data = NULL, group = NULL, title = NULL) {
  var_name <- rlang::as_name(rlang::ensym(var))
  var_vals <- resolve_var(!!rlang::ensym(var), data)
  
  if (is.null(title)) {
    title <- paste("Boxplot of", var_name)
  }
  
  if (!is.null(group)) {
    group_name <- rlang::as_name(rlang::ensym(group))
    group_vals <- resolve_var(!!rlang::ensym(group), data)
    plot_data <- data.frame(var = var_vals, group = as.factor(group_vals))
    
    p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = group, y = var, fill = group)) +
      ggplot2::geom_boxplot(alpha = 0.7) +
      ggplot2::scale_fill_brewer(palette = "Set2") +
      ggplot2::labs(title = title, x = group_name, y = var_name) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
        legend.position = "none"
      )
  } else {
    plot_data <- data.frame(var = var_vals, x = "")
    
    p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = x, y = var)) +
      ggplot2::geom_boxplot(fill = "#A06CD5", alpha = 0.7, width = 0.5) +
      ggplot2::labs(title = title, x = "", y = var_name) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
        axis.text.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank()
      )
  }
  
  print(p)
  invisible(p)
}

#' Create pie chart(s)
#'
#' @param var Variable to plot (bare name)
#' @param filter Optional filter variable to create multiple charts (bare name, no quotes needed)
#' @param data Optional data frame
#' @param title Chart title
#' @param show_percent Show percentage labels (default: TRUE)
#' @return A ggplot object or patchwork composition
#' @export
#' @examples
#' \dontrun{
#' mydata <- data.frame(category = c("A","B","C","A","B"), 
#'                      group = c("X","X","X","Y","Y"))
#' piechart(category)
#' piechart(category, filter = group)
#' }
piechart <- function(var, filter = NULL, data = NULL, title = NULL, show_percent = TRUE) {
  var_name <- rlang::as_name(rlang::ensym(var))
  var_vals <- resolve_var(!!rlang::ensym(var), data)
  
  if (is.null(filter)) {
    # Single pie chart
    count_data <- as.data.frame(table(var_vals))
    names(count_data) <- c("category", "count")
    count_data$percent <- count_data$count / sum(count_data$count)
    count_data$label <- scales::percent(count_data$percent, accuracy = 0.1)
    
    if (is.null(title)) title <- paste("Piechart of", var_name)
    
    p <- ggplot2::ggplot(count_data, ggplot2::aes(x = "", y = count, fill = category)) +
      ggplot2::geom_bar(stat = "identity", width = 1, color = "white", linewidth = 1) +
      ggplot2::coord_polar("y", start = 0) +
      ggplot2::scale_fill_brewer(palette = "Set3", name = var_name) +
      ggplot2::labs(title = title) +
      ggplot2::theme_void(base_size = 12) +
      ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5))
    
    if (show_percent) {
      p <- p + ggplot2::geom_text(ggplot2::aes(label = label), 
                                  position = ggplot2::position_stack(vjust = 0.5),
                                  size = 4, fontface = "bold")
    }
    
    print(p)
    invisible(p)
    
  } else {
    # Multiple pie charts by filter
    filter_name <- rlang::as_name(rlang::ensym(filter))
    filter_vals <- resolve_var(!!rlang::ensym(filter), data)
    
    plot_data <- data.frame(var = var_vals, filter = filter_vals)
    filter_levels <- unique(filter_vals)
    
    plots <- lapply(filter_levels, function(level) {
      subset_data <- plot_data[plot_data$filter == level, ]
      count_data <- as.data.frame(table(subset_data$var))
      names(count_data) <- c("category", "count")
      count_data$percent <- count_data$count / sum(count_data$count)
      count_data$label <- scales::percent(count_data$percent, accuracy = 0.1)
      
      # Use different color palette for each pie
      palette_num <- match(level, filter_levels) %% 8 + 1
      palette_name <- c("Set3", "Pastel1", "Set2", "Pastel2", "Dark2", "Accent", "Set1", "Paired")[palette_num]
      
      p <- ggplot2::ggplot(count_data, ggplot2::aes(x = "", y = count, fill = category)) +
        ggplot2::geom_bar(stat = "identity", width = 1, color = "white", linewidth = 1) +
        ggplot2::coord_polar("y", start = 0) +
        ggplot2::scale_fill_brewer(palette = palette_name, name = var_name) +
        ggplot2::labs(title = paste(filter_name, "=", level), 
                      subtitle = paste("n =", sum(count_data$count))) +
        ggplot2::theme_void(base_size = 10) +
        ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                       plot.subtitle = ggplot2::element_text(hjust = 0.5))
      
      if (show_percent) {
        p <- p + ggplot2::geom_text(ggplot2::aes(label = label), 
                                    position = ggplot2::position_stack(vjust = 0.5),
                                    size = 3.5, fontface = "bold")
      }
      p
    })
    
    # Combine plots
    combined <- patchwork::wrap_plots(plots, ncol = min(length(plots), 3))
    if (!is.null(title)) {
      combined <- combined + patchwork::plot_annotation(title = title,
                                                        theme = ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5, size = 14)))
    }
    
    print(combined)
    invisible(combined)
  }
}

#' Compute descriptive statistics
#'
#' @param ... Variables to analyze (bare names)
#' @param data Optional data frame
#' @param stats Statistics to compute
#' @return A data frame with statistics
#' @export
#' @examples
#' \dontrun{
#' mydata <- data.frame(x = rnorm(100), y = rnorm(100))
#' descriptives(x, y)
#' }
descriptives <- function(..., data = NULL, stats = c("mean", "sd", "median", "min", "max", "n")) {
  vars <- rlang::enquos(...)
  
  results <- list()
  
  for (v in vars) {
    var_name <- rlang::as_name(v)
    var_vals <- resolve_var(!!v, data)
    
    var_stats <- list(Variable = var_name)
    
    if ("n" %in% stats) var_stats$N <- length(var_vals[!is.na(var_vals)])
    if ("mean" %in% stats) var_stats$Mean <- round(mean(var_vals, na.rm = TRUE), 2)
    if ("sd" %in% stats) var_stats$SD <- round(sd(var_vals, na.rm = TRUE), 2)
    if ("median" %in% stats) var_stats$Median <- round(median(var_vals, na.rm = TRUE), 2)
    if ("min" %in% stats) var_stats$Min <- round(min(var_vals, na.rm = TRUE), 2)
    if ("max" %in% stats) var_stats$Max <- round(max(var_vals, na.rm = TRUE), 2)
    
    results[[length(results) + 1]] <- var_stats
  }
  
  result_df <- do.call(rbind, lapply(results, as.data.frame))
  rownames(result_df) <- NULL
  
  print(result_df)
  invisible(result_df)
}

#' Create frequency table
#'
#' @param var Variable to tabulate (bare name)
#' @param data Optional data frame
#' @param percent Show percentages (default: TRUE)
#' @param sort Sort order: "desc", "asc", or "none"
#' @return A data frame with frequencies
#' @export
#' @examples
#' \dontrun{
#' mydata <- data.frame(category = sample(LETTERS[1:3], 100, replace = TRUE))
#' frequencies(category)
#' }
frequencies <- function(var, data = NULL, percent = TRUE, sort = "desc") {
  var_name <- rlang::as_name(rlang::ensym(var))
  var_vals <- resolve_var(!!rlang::ensym(var), data)
  
  freq_table <- as.data.frame(table(var_vals))
  names(freq_table) <- c(var_name, "Count")
  
  if (percent) {
    freq_table$Percent <- round(freq_table$Count / sum(freq_table$Count) * 100, 1)
  }
  
  if (sort == "desc") {
    freq_table <- freq_table[order(-freq_table$Count), ]
  } else if (sort == "asc") {
    freq_table <- freq_table[order(freq_table$Count), ]
  }
  
  rownames(freq_table) <- NULL
  
  print(freq_table)
  invisible(freq_table)
}