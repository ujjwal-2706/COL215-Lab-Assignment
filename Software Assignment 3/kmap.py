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
def terms_used_reduction(reduced_term,remaining_term):
    given_terms = produce_terms(reduced_term)
    total_terms = set({})
    for term in given_terms:
        term.extend(remaining_term)
        term.sort()
        total_terms.add(''.join(term))
    return total_terms
def maximal_expansion(possible_terms,term):
    remaining_term = break_literal(term)
    reduced_term = []
    total_used_terms = set({})
    while True:
        reduction_possible = False
        for index in range(len(remaining_term)):
            remaining_term[index] = complement(remaining_term[index])
            reduce_temp = [val for val in reduced_term]
            if all_possible_terms_check(reduce_temp,remaining_term,possible_terms):
                reduce_new = [val for val in reduced_term]
                remaining_new = [val for val in remaining_term]
                reduction_possible = True
                #uncomment these lines to print intermediate terms
                # remaining_new[index] = complement(remaining_new[index])
                # term = ''.join(remaining_new)
                # print(f"Expanded Term is : {term}")
                # remaining_new[index] = complement(remaining_new[index])
                # intermediate_term_print(reduce_new,remaining_new)
                value = remaining_term.pop(index)
                # print(f"earlier value : {remaining_term}")
                reduced_term.append(value)
                new_reduced = [val for val in reduced_term]
                new_remain = [val for val in remaining_term]
                term_list = terms_used_reduction(new_reduced,new_remain)
                total_used_terms = total_used_terms.union(term_list)
                # print(f"after value : {reduced_term}")
                break
            else:
                remaining_term[index] = complement(remaining_term[index])
        if not reduction_possible:
            break
    remaining_term.sort()
    return "".join(remaining_term),total_used_terms
def comb_function_expansion(func_TRUE, func_DC):
    possible_terms = set({})
    for term in func_TRUE:
        possible_terms.add(term)
    for term_not_care in func_DC:
        possible_terms.add(term_not_care)
    answer = []
    for term in func_TRUE:
        value,terms_used = maximal_expansion(possible_terms,term)
        answer.append(value)
    return answer
# value = comb_function_expansion(['abc',"a'bc"],["abc'","ab'c","ab'c'"])
# print(value)

#this function will check if a given literal term is subsequence of other or not
def subsequence_check(literal_list1,literal_list2):
    if len(literal_list1) < len(literal_list2):
        pointer1 = 0
        pointer2 = 0
        while pointer1 < len(literal_list1) and pointer2 < len(literal_list2):
            if literal_list1[pointer1] == literal_list2[pointer2]:
                pointer1 += 1
            pointer2 += 1
        if pointer1 == len(literal_list1):
            return True
        else:
            return False
    else:
        return False
def opt_function_reduce(func_TRUE, func_DC):
    possible_terms = set({})
    for term in func_TRUE:
        possible_terms.add(term)
    for term_not_care in func_DC:
        possible_terms.add(term_not_care)
    expansion  = comb_function_expansion(func_TRUE,func_DC)
    answer = []
    terms_freq = {}
    for i in range(len(expansion)):
        term1= break_literal(expansion[i])
        value = False
        for j in range(len(expansion)):
            term2 = break_literal(expansion[j])
            # if value is true means we found a terms more superior
            value = value or subsequence_check(term2,term1)
        if not value:
            temp,cover_new = maximal_expansion(possible_terms,func_TRUE[i])
            for element in cover_new:
                if element in func_TRUE:
                    if element in terms_freq:
                        terms_freq[element] += 1
                    else:
                        terms_freq[element] = 1
    for i in range(len(expansion)):
        term1= break_literal(expansion[i])
        value = False
        for j in range(len(expansion)):
            term2 = break_literal(expansion[j])
            # if value is true means we found a terms more superior
            value = value or subsequence_check(term2,term1)
        if not value:
            temp,cover_new = maximal_expansion(possible_terms,func_TRUE[i])
            add = False
            for element in cover_new:
                if element in func_TRUE:
                    if terms_freq[element] == 1:
                        add = True
                        break
            if add:
                answer.append(expansion[i])
            else:
                for element in cover_new:
                    if element in func_TRUE:
                        terms_freq[element] -= 1
    return list(set(answer))

print("Sample Test 2")
print(opt_function_reduce(["a'b'c'd", "a'b'cd", "a'bc'd", "abc'd'", "abc'd", "ab'c'd'", "ab'cd"],["a'bc'd'", "a'bcd", "ab'c'd"]))
print("Sample Test 3")
print(opt_function_reduce(["a'b'c", "a'bc", "a'bc'", "ab'c'"],["abc'"]))
print("Sample Test 4")
print(opt_function_reduce(["a'b'c'd'e'", "a'bc'd'e'", "abc'd'e'", "ab'c'd'e'", "abc'de'", "abcde'",
"a'bcde'", "a'bcd'e'", "abcd'e'", "a'bc'de", "abc'de", "abcde",
"a'bcde", "a'bcd'e", "abcd'e", "a'b'cd'e", "ab'cd'e"]
,[]))
print("Sample Test 1")
print(opt_function_reduce(["a'bc'd'", "abc'd'", "a'b'c'd", "a'bc'd", "a'b'cd"],["abc'd"]))
