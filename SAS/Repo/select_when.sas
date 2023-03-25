/* Select processing, similar to if statement. Allows for more flexibility with variable creation */
DATA OUTPUT_DATA;
  length new_var $7.; *create new variable to be used within select statement. Ensures max length is 7 characters;
  SET INPUT_DATA;
    select (variable);
      when () new_var = "group1";
      when () new_var = "";
      otherwise new_var = "";
    end;
RUN;
