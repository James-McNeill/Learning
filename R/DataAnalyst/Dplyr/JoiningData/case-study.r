# Case Study: Working with Stack Overflow

# A. Initial insights
# 1. Left joining
questions %>%
  left_join(question_tags, by = c("id" = "question_id")) %>%
  left_join(tags, by = c("tag_id" = "id")) %>%
  replace_na(list(tag_name = "only-r"))

# 2. Compare scores across tags
questions_with_tags %>%
	# Group by tag_name
	group_by(tag_name) %>%
	# Get mean score and num_questions
	summarize(score = mean(score),
          	  num_questions = n()) %>%
	# Sort num_questions in descending order
	arrange(desc(num_questions))

# 3. Tags that never appear on R questions
# Using a join, filter for tags that are never on an R question
tags %>%
    anti_join(question_tags, by = c("id" = "tag_id"))

# B. Reviewing questions and answers
# 1. Finding the gap
questions %>%
	# Inner join questions and answers with proper suffixes
	inner_join(answers, by = c("id" = "question_id"), suffix = c("_question", "_answer")) %>%
	# Subtract creation_date_question from creation_date_answer to create gap
	mutate(gap = as.integer(creation_date_answer - creation_date_question))

# 2. Joining question and answer counts
# Count and sort the question id column in the answers table
answer_counts <- answers %>%
	count(question_id) %>% arrange(question_id)

# Combine the answer_counts and questions tables
questions %>%
	full_join(answer_counts, by = c("id" = "question_id")) %>%
	# Replace the NAs in the n column
	replace_na(list(n = 0))

# 3. Adding tags information
question_answer_counts %>%
	# Join the question_tags tables
	inner_join(question_tags, by = c("id" = "question_id")) %>%
	# Join the tags table
	inner_join(tags, by = c("tag_id" = "id"))

# 4. Average number of answers by question
tagged_answers %>%
	# Aggregate by tag_name
    group_by(tag_name) %>%
	# Summarize questions and average_answers
    summarize(questions = n(),
              average_answers = mean(n)) %>%
	# Sort the questions in descending order
    arrange(desc(questions))
