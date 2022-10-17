#this function will give all the rows or columns that need to be removed 
#if we have a corresponding literal term appearing
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
