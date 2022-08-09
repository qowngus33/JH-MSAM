# system programmin assembly language assignment

First, the Irvine library's path was included at the top of the program to use, and several necessary numerical and character arrays were declared on the data segment part.

<img width="721" alt="Image" src="https://user-images.githubusercontent.com/83813866/183595860-90fe5191-4cb5-45e5-b5bb-0454738ac36c.png">

Prompt 1, 2, and 3 define the message to be displayed on the screen as zero terminal string when calling the WriteString procedure in the Irvine library within the main procedure, and array is an array of 20 six-byte unsigned integers. temp, tempSum variable is also a temporary array used to add all elements of the array

<img width="720" alt="스크린샷 2022-06-09 오후 4 54 13" src="https://user-images.githubusercontent.com/83813866/183596071-4a7ec1f0-6c0d-4f3a-98cb-9ad449bc1594.png">

Within the main procedure, the Irvine library Randomize procedure, which outputs prompt1 string and initializes the RandomRange procedure start seed value of the Irvine library, is called before the RandomRange procedure call, so that a different number can be generated each time the program runs.

<img width="720" alt="Image" src="https://user-images.githubusercontent.com/83813866/183596159-df1f0912-f9ac-4ef9-81ba-a059b084d4d5.png">

Then, 20 6byte unsigned integers were created by allocating random numbers between 0-255 for each BYTE in the array using RandomRange procedures in the Irvine library. At the moment, esi register pointed to the starting address of the array, and using a double loop, the outer loop was rotated 20 times and the inner loop was rotated 6 times to assign a number to each position in the array.

<img width="718" alt="Image" src="https://user-images.githubusercontent.com/83813866/183596588-5c5c256e-5d9f-44c8-97b8-4d1dd553bf69.png">

Then, the Diplay_num procedure implemented in the asm file was used to output 20 randomly generated array elements on the screen. In order to space out the elements while outputting them, the WriteChar procedure was called by putting a blank(spacebar) in the eax register.
<img width="719" alt="Image" src="https://user-images.githubusercontent.com/83813866/183596857-84c679c1-dcef-4156-932d-9c9599d21097.png">

The Display_sum procedure uses the WriteHexB function of the Irvine library to cut and output values on the data segment in a byte.

<img width="718" alt="Image" src="https://user-images.githubusercontent.com/83813866/183596999-0e4e57e7-a05f-4bb7-bdb0-a6ed98fd923e.png">

The 20 elements of the array were then added using three procedures: MOV_ARRAY_VALUE, EXTENDED_ADD, and MOV_SUM_VALUE.

<img width="633" alt="스크린샷 2022-08-09 오후 5 13 11" src="https://user-images.githubusercontent.com/83813866/183599170-c34dbcdf-c2ef-4a3b-b304-8505c01d2ece.png">

MOV_ARRAY_VALUE is a procedure that moves the value of the array to temp, and MOV_SUM_VALUE is a procedure that moves the value of the sum to tempSum. array, sum, and tempSum are arrays of a byte size declared on the data segment.

Basically, the sum of all elements in an array array consists of the following processes.

	1. array → temp (take one additional number from array and transfer it to temp.)
	2. temp + tempSum = sum
	3. Sum → tempSum (Transfer the value of sum to tempSum).)

When all of the above processes are completed, sum is stored with the sum of all elements of the array array.

Since the sum of all elements is obtained, divide it by 20 to obtain the average. The process of obtaining the average is as follows.

<img width="716" alt="Image" src="https://user-images.githubusercontent.com/83813866/183598140-9d2bca06-6d92-4aee-90d9-a283d762ba1f.png">

	1. Remove the bits as large as the size of the divisor (20) from the MSB of the diviend (sum) and transfer them to the diviend piece (edi).
	2. Compare the diviend piece and divisor.
	3. If the diviend piece is greater than or equal to the divisor, the quotient is 1 and the remainder is the diviend piece minus the divisor. If there is a previously obtained share, shift one bit to the left to add to the newly obtained share.
	4. Otherwise, the quotient is zero and the rest is a piece of divisor. If you have a previously obtained share, shift one bit to the left to add to the newly obtained share.
	5. Take the following bits from the diviend piece and combine them to the back of the rest to make a new fragment of the divisor, and then perform process 2 again.
  	6. Repeat steps 3-6 until there are no more bits left in the diviend.

The quotient of sum obtained through the above process divided by 20 is an integer average

<img width="719" alt="Image" src="https://user-images.githubusercontent.com/83813866/183598194-37b89756-fbc6-4034-864b-6b52c4e13726.png">

<img width="1512" alt="스크린샷 2022-06-07 오후 7 40 12" src="https://user-images.githubusercontent.com/83813866/183598042-14e81f05-e53d-461c-b891-55ca2ab85032.png">

