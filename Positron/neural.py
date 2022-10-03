#784 * 64 weights 64 *1 bias and 64*10 weights 10 bias
imgfile = open("imgdata.txt",'r')
img_data = imgfile.readlines()
imgfile.close()
weight_bias = open("weights_bias.txt",'r')
weights_bias_data = weight_bias.readlines()
weight_bias.close()
def convert_to_int(binary_string):
    power = 1
    value = 0
    for index in range(len(binary_string)-1,0,-1):
        if binary_string[index] != '\n':
            value += (power * int(binary_string[index]))
            power *= 2
    value -= (power * int(binary_string[0]))
    return value

def signed_int(integer,bits):
    answer = []
    if integer < 0:
        answer.append('1')
        integer += 2**(bits-1)
    else:
        answer.append('0')
    digits = []
    while len(digits) < bits-1:
        val = integer%2
        integer //= 2
        digits.append(str(val))
    for index in range(len(digits)-1,-1,-1):
        answer.append(digits[index])
    return "".join(answer)
    
img_data = list(map(convert_to_int,img_data))
weight_bias_data = list(map(convert_to_int,weights_bias_data))
def layer1():
    answer = [0 for i in range(64)]
    for index in range(64):
        result = 0
        for img in range(784):
            value = img_data[img] * weight_bias_data[index*784 + img]
            # print((signed_int(value,24)))
            value = convert_to_int((signed_int(value,24))[8:])
            result += value
            result = convert_to_int((signed_int(result,17))[1:])
        result += weight_bias_data[index + 50176]
        result = convert_to_int((signed_int(result,17))[1:])
        if result > 0 :
            result //= 32
            answer[index] = result
    return answer

layer1_output = layer1()
def layer2():
    answer = [0 for i in range(10)]
    for index in range(10):
        result = 0
        for act in range(64):
            value = layer1_output[act] * weight_bias_data[50240+index*64 + act]
            value = convert_to_int((signed_int(value,24))[8:])
            result += value
            result = convert_to_int((signed_int(result,17))[1:])
        result += weight_bias_data[index + 50880]
        result = convert_to_int((signed_int(result,17))[1:])
        if result > 0 :
            result //= 32
            answer[index] = result
    return answer
layer2_output = layer2()
max_index = 0
for i in range(10):
    if layer2_output[i] > layer2_output[max_index]:
        max_index = i
print(max_index)
print(layer1_output)
print(layer2_output)