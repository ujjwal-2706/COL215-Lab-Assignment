#this function will break the term into list of literal characters like ["a'","b","c"]
def break_literal(term):
    answer = []
    end_index = 0
    while end_index < len(term):
        start_index = end_index
        end_index += 1
        while end_index < len(term) and ord(term[end_index]) == 39 :
            end_index += 1
            break
        new_literal = term[start_index:end_index]
        answer.append(new_literal)
    return answer
def complement(single_literal):
    if len(single_literal) == 2:
        return single_literal[0]
    else:
        return single_literal + "'"

#a list of literal
def produce_terms(reduced_term):
    if len(reduced_term) == 1:
        return [reduced_term,[complement(reduced_term[0])]]
    else:
        last = reduced_term.pop()
        value = produce_terms(reduced_term)
        answer = []
        for literal_list in value:
            new_value = [term for term in literal_list]
            new_value.append(last)
            literal_list.append(complement(last))
            answer.append(new_value)
            answer.append(literal_list)
        return answer
#reduced term is list of all the reduced terms so far hence the bound would be on log of n(number of terms in possible terms)
def all_possible_terms_check(reduced_term,remaining_term,possible_terms):
    if len(reduced_term) == 0:
        remaining_term.sort()
        final_term = "".join(remaining_term)
        if final_term not in possible_terms:
            return False
        else:
            return True
    produced_terms = produce_terms(reduced_term)
    for terms in produced_terms:
        terms.extend(remaining_term)
        terms.sort()
        final_term = "".join(terms)
        if final_term not in possible_terms:
            return False
    return True
def intermediate_term_print(reduced_term,remaining_term):
    if len(reduced_term) == 0:
        remaining_term.sort()
        final_term = "".join(remaining_term)
        print(f"Terms used to reduce : {[final_term]}")
    else:
        produced_terms = produce_terms(reduced_term)
        answer = []
        for terms in produced_terms:
            terms.extend(remaining_term)
            terms.sort()
            final_term = "".join(terms)
            answer.append(final_term)
        print(f"Terms used to reduce : {answer}")
def maximal_expansion(possible_terms,term):
    remaining_term = break_literal(term)
    reduced_term = []
    while True:
        reduction_possible = False
        for index in range(len(remaining_term)):
            remaining_term[index] = complement(remaining_term[index])
            reduce_temp = [val for val in reduced_term]
            if all_possible_terms_check(reduce_temp,remaining_term,possible_terms):
                reduce_new = [val for val in reduced_term]
                remaining_new = [val for val in remaining_term]
                reduction_possible = True
                #uncomment this line to print intermediate terms
                # intermediate_term_print(reduce_new,remaining_new)
                value = remaining_term.pop(index)
                reduced_term.append(value)
                break
            else:
                remaining_term[index] = complement(remaining_term[index])
        if not reduction_possible:
            break
    remaining_term.sort()
    return "".join(remaining_term)
def comb_function_expansion(func_TRUE, func_DC):
    possible_terms = set({})
    for term in func_TRUE:
        possible_terms.add(term)
    for term_not_care in func_DC:
        possible_terms.add(term_not_care)
    answer = []
    for term in func_TRUE:
        value = maximal_expansion(possible_terms,term)
        answer.append(value)
    return answer
 value = comb_function_expansion(["a'b'c'd'e'", "a'b'cd'e", "a'b'cde'", "a'bc'd'e'", "a'bc'd'e", "a'bc'de", "a'bc'de'", "ab'c'd'e'", "ab'cd'e'"], ["abc'd'e'", "abc'd'e", "abc'de", "abc'de'"])
 print(value)
