# from K_map_gui_tk import *

def row_col_invalid(term_index,term,total_row,total_col):
    row = False
    #look at the columns
    if term_index < (len(term)+1)//2:
        diff = (len(term)+1)//2 - term_index-1 
        variation = 2**diff
        index = 0
        reverse = False
        invalid_col = set({})
        if term[term_index] == 1:
            while index < total_col:
                count = 0
                if not reverse:
                    while count < variation:
                        if index < total_col:
                            invalid_col.add(index)
                        count += 1
                        index += 1
                    while count < 2*variation:
                        count += 1
                        index += 1
                    reverse = True
                else:
                    while count < variation:
                        count += 1
                        index += 1
                    while count < 2*variation:
                        if index < total_col:
                            invalid_col.add(index)
                        count += 1
                        index += 1
                    reverse = False
        else:
            while index < total_col:
                count = 0
                if reverse:
                    while count < variation:
                        if index < total_col:
                            invalid_col.add(index)
                        count += 1
                        index += 1
                    while count < 2*variation:
                        count += 1
                        index += 1
                    reverse = False
                else:
                    while count < variation:
                        count += 1
                        index += 1
                    while count < 2*variation:
                        if index < total_col:
                            invalid_col.add(index)
                        count += 1
                        index += 1
                    reverse = True
        return invalid_col,False
    #look at the rows
    else:
        diff = len(term) - term_index - 1
        variation = 2**diff
        index = 0
        reverse = False
        invalid_row = set({})
        if term[term_index] == 1:
            while index < total_row:
                count = 0
                if not reverse:
                    while count < variation:
                        if index < total_row:
                            invalid_row.add(index)
                        count += 1
                        index += 1
                    while count < 2*variation:
                        count += 1
                        index += 1
                    reverse = True
                else:
                    while count < variation:
                        count += 1
                        index += 1
                    while count < 2*variation:
                        if index < total_row:
                            invalid_row.add(index)
                        count += 1
                        index += 1
                    reverse = False
        else:
            while index < total_row:
                count = 0
                if reverse:
                    while count < variation:
                        if index < total_row:
                            invalid_row.add(index)
                        count += 1
                        index += 1
                    while count < 2*variation:
                        count += 1
                        index += 1
                    reverse = False
                else:
                    while count < variation:
                        count += 1
                        index += 1
                    while count < 2*variation:
                        if index < total_row:
                            invalid_row.add(index)
                        count += 1
                        index += 1
                    reverse = True
        return invalid_row,True


def is_legal_region(kmap_function, term):
    row = len(kmap_function)
    col = len(kmap_function[0])
    legal = True
    row_valid = set([i for i in range(row)])
    col_valid = set([j for j in range(col)])
    for  term_index in range(len(term)):
        if term[term_index] is not None:
            invalid,ifRows = row_col_invalid(term_index,term,row,col)
            if ifRows :
                for element in invalid:
                    if element in row_valid:
                        row_valid.remove(element)
            else:
                for element in invalid:
                    if element in col_valid:
                        col_valid.remove(element)
    for row_num in range(row):
        for col_num in range(col):
            if row_num in row_valid and col_num in col_valid : 
                if kmap_function[row_num][col_num] == 0:
                    legal = False
    final_rows = sorted(list(row_valid))
    final_cols = sorted(list(col_valid))
    topLeft = [final_rows[0],final_cols[0]]
    bottomRight = [final_rows[len(final_rows)-1],final_cols[len(final_cols)-1]]
    if len(final_rows) > 1 and final_rows[0] +1 != final_rows[1]:
        topLeft[0] = final_rows[len(final_rows)-1]
        bottomRight[0] = final_rows[0]
    if len(final_cols) > 1 and final_cols[0] + 1 != final_cols[1]:
        topLeft[1] = final_cols[len(final_cols)-1]
        bottomRight[1] = final_cols[0]
    return ((topLeft[0],topLeft[1]),(bottomRight[0],bottomRight[1]),legal)

# def is_legal_region(kmap_function, term):
#     row = len(kmap_function)
#     col = len(kmap_function[0])
#     legal = True
#     row_valid = set([i for i in range(row)])
#     col_valid = set([j for j in range(col)])
#     if row  == 2 and col == 2: #means 2 variables
#         for index in range(len(term)):
#             if term[index] is not None:
#                 if index == 0:
#                     if term[index] == 1:
#                         col_valid.remove(0)
#                     else:
#                         col_valid.remove(1)
#                 elif index == 1:
#                     if term[index] == 1:
#                         row_valid.remove(0)
#                     else:
#                         row_valid.remove(1)
#     elif row == 2 and col == 4: # means 3 variables
#         for index in range(len(term)):
#             if term[index] is not None:
#                 if index == 0:
#                     if term[index] == 1:
#                         if 0 in col_valid:
#                             col_valid.remove(0)
#                         if 1 in col_valid:
#                             col_valid.remove(1)
#                     else:
#                         if 2 in col_valid:
#                             col_valid.remove(2)
#                         if 3 in col_valid:
#                             col_valid.remove(3)
#                 elif index == 1:
#                     if term[index] == 1:
#                         if 0 in col_valid:
#                             col_valid.remove(0)
#                         if 3 in col_valid:
#                             col_valid.remove(3)
#                     else:
#                         if 1 in col_valid:
#                             col_valid.remove(1)
#                         if 2 in col_valid:
#                             col_valid.remove(2)
#                 elif index == 2:
#                     if term[index] == 1:
#                         row_valid.remove(0)
#                     else:
#                         row_valid.remove(1)
#     elif row == 4 and col == 4: # means 4 variables
#         for index in range(len(term)):
#             if term[index] is not None:
#                 if index == 0:
#                     if term[index] == 1:
#                         if 0 in col_valid:
#                             col_valid.remove(0)
#                         if 1 in col_valid:
#                             col_valid.remove(1)
#                     else:
#                         if 2 in col_valid:
#                             col_valid.remove(2)
#                         if 3 in col_valid:
#                             col_valid.remove(3)
#                 elif index == 1:
#                     if term[index] == 1:
#                         if 0 in col_valid:
#                             col_valid.remove(0)
#                         if 3 in col_valid:
#                             col_valid.remove(3)
#                     else:
#                         if 1 in col_valid:
#                             col_valid.remove(1)
#                         if 2 in col_valid:
#                             col_valid.remove(2)
#                 elif index == 2:
#                     if term[index] == 1:
#                         if 0 in row_valid:
#                             row_valid.remove(0)
#                         if 1 in row_valid:
#                             row_valid.remove(1)
#                     else:
#                         if 2 in row_valid:
#                             row_valid.remove(2)
#                         if 3 in row_valid:
#                             row_valid.remove(3)
#                 elif index == 3:
#                     if term[index] == 1:
#                         if 0 in row_valid:
#                             row_valid.remove(0)
#                         if 3 in row_valid:
#                             row_valid.remove(3)
#                     else:
#                         if 1 in row_valid:
#                             row_valid.remove(1)
#                         if 2 in row_valid:
#                             row_valid.remove(2)
#     for row_num in range(row):
#         for col_num in range(col):
#             if row_num in row_valid and col_num in col_valid : 
#                 if kmap_function[row_num][col_num] == 0:
#                     legal = False
#     final_rows = sorted(list(row_valid))
#     final_cols = sorted(list(col_valid))
#     topLeft = [final_rows[0],final_cols[0]]
#     bottomRight = [final_rows[len(final_rows)-1],final_cols[len(final_cols)-1]]
#     if len(final_rows) > 1 and final_rows[0] +1 != final_rows[1]:
#         topLeft[0] = final_rows[len(final_rows)-1]
#         bottomRight[0] = final_rows[0]
#     if len(final_cols) > 1 and final_cols[0] + 1 != final_cols[1]:
#         topLeft[1] = final_cols[len(final_cols)-1]
#         bottomRight[1] = final_cols[0]
#     return ((topLeft[0],topLeft[1]),(bottomRight[0],bottomRight[1]),legal)

#testing
# kmap_grid = [[0 for j in range(4)] for i in range(4)]
# kmap_grid[0][1] = 1
# kmap_grid[0][2] = 1
# kmap_grid[1][0] = 'x'
# kmap_grid[1][1] = 1
# kmap_grid[1][2] = 'x'
# kmap_grid[2][0] = 1
# kmap_grid[3][0] = 1
# kmap_grid[3][1] = 'x'
# # """
# #  0 1 1 0
# #  x 1 x 0
# #  1 0 0 0
# #  1 x 0 0
# # """

# print(is_legal_region(kmap_grid,[None, 0, 1, 0]))
# print(is_legal_region(kmap_grid,[None, 1,0, None]))
# tpLeft1,btRight1, legal1 = is_legal_region(kmap_grid,[None,0,1,0])
# tpLeft2,btRight2, legal2 = is_legal_region(kmap_grid,[None,1,0,None])
# root = kmap(kmap_grid)
# root.draw_region(tpLeft1[0],tpLeft1[1],btRight1[0],btRight1[1],'green')
# root.draw_region(tpLeft2[0],tpLeft2[1],btRight2[0],btRight2[1],'orange')
# root.mainloop()