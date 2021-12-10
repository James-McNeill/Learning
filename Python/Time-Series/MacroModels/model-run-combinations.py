# Model run combinations analysis

# Code continues from the model-run.py module when introducing the data and performing initial transformations.
# Aim of this code is to understand which variable combinations produce the best models

# A. Import the final independent variables. This list relates to the variable transformations that will be checked.
# The independent variables have been transformed prior to this list being used.
# Import the independent variable excel file
df_final_ind = pd.read_excel('Final_Independent_Variables.xlsx',engine='openpyxl')
df_final_ind

# List for the independent variables
df_indep_list = [x for x in df_final_ind['VARIABLE']]
df_indep_list

# B. Creating variable combinations
# Review all two factor combinations
combs2 = list(itertools.combinations(df_indep_list, r=2))
# print(combs2)
print(f'Number of two factor combinations = {len(combs2)}')
for index, tuples in enumerate(combs2):
    var1 = tuples[0]
    var2 = tuples[1]
    print(f'Index : {index}, variable 1 : {var1} & variable 2 : {var2}')

# Review all three factor combinations
combs3 = list(itertools.combinations(df_indep_list, r=3))
# print(combs3)
print(f'Number of three factor combinations = {len(combs3)}')
for index, tuples in enumerate(combs3):
    var1 = tuples[0]
    var2 = tuples[1]
    var3 = tuples[2]
    print(f'Index : {index}, variable 1 : {var1} & variable 2 : {var2} & variable 3 : {var3}')

# C. Multi Factor analysis
# Multi Factor model outputs - two factors
# df_ind2: relates to the transformed independent variables
# df_dep: relates to the transformed dependent variables
# var_combs: default value of 2
dep = 'ODR_X'
df_mfa2 = stmd.MultiFactor(df_ind2, df_indep_list, df_dep, dep).main()
df_mfa2

# Multi Factor model outputs - three factors
df_mfa3 = stmd.MultiFactor(df_ind2, df_indep_list, df_dep, dep, var_combs=3).main()
df_mfa3
