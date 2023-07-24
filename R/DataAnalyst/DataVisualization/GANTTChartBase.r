# Baseline GANTT chart
# Load the required packages
library(ggplot2)

# Create a data frame with task information
tasks <- data.frame(
  Task = c("Task 1", "Task 2", "Task 3", "Task 4", "Task 5"),
  Start = c(as.Date("2023-04-01"), as.Date("2023-04-05"), as.Date("2023-04-08"), as.Date("2023-04-11"), as.Date("2023-04-15")),
  End = c(as.Date("2023-04-04"), as.Date("2023-04-10"), as.Date("2023-04-14"), as.Date("2023-04-16"), as.Date("2023-04-20"))
)

# Create the Gantt chart
ggplot(tasks, aes(x = Start, xend=End, y = Task, yend=Task, color = Task)) +
  geom_segment(size=8) +
  labs(x = "Date", y = "Task", title = "Gantt Chart") +
  # scale_x_date(date_breaks = "1 day", date_labels = "%b %d") +
  theme_minimal()
