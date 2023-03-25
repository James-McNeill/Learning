/* Select processing, similar to if statement. Allows for more flexibility with variable creation */
DATA OUTPUT_DATA;
  length new_var $7.; *create new variable to be used within select statement. Ensures max length is 7 characters;
  SET INPUT_DATA;
    select (variable); *variable to be queried to create the new_var derived variable;
      when ("option1", "option2") new_var = "group1";
      when ("option3") new_var = "group2";
      otherwise new_var = "group3";
    end;
RUN;
