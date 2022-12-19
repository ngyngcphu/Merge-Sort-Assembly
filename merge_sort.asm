# Chuong trinh Assembly Merge Sort tren tap lenh MIPS
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
.data
intial_array:	.asciiz "Array: \n"
print_step:	.asciiz "Step "
merge_sorting:	.asciiz "\n>>>>MERGE SORT<<<<\n"
new_line:	.asciiz "\n"
space:		.asciiz	" "
print_colon:	.asciiz ": "

array:		.word -33, 78, -17, 8, -44, 81, 89, -100, 85, 38, 70, -79, 35, 33, 96, 74, 69, 66, -69, -22, -35, 56, -57, 80, 39, 76, 34, -92, -74, -68, 67, -1, -60, 49, 48, -11, 6, -39, 16, -93, -18, 22, -41, -36, 23, 88, -71, 11, 44, -45

arr_temp1: 	.space 200
arr_temp2:	.space 200
#----------------------------------------------------------------------------------#
.text
main:
	jal 	print_initial_array

	la	$a0, array		# a0 luu mang
	addi	$a1, $zero, 0		# a1 = left
	
	addi	$a2, $zero, 50
	addi	$a2, $a2, -1		# a2 = right
	
	addi	$s1, $a1, 0		# s1 = 0
	addi	$s2, $a2, 0		# s2 = size - 1
	addi	$s6, $zero, 1		# bien dem Step dung de in print_step_array (VD: Step 1, Step2,...)
	
	jal	merge_sort		# Merge sort
	
	addi  	$v0, $zero, 10			# Done!
	syscall
#----------------------------------------------------------------------------------#
merge_sort:
# a0 luu mang array
# a1 = left
# a2 = right
	beq	$a1, $a2, stop_sorting	# stop khi left = right
	
	add	$a3, $a1, $a2	
	
	div	$a3, $a3, 2		# a3 = middle
	
	addi	$sp, $sp, -16		# cap phat 4 o trong stack
	sw	$a1, 0($sp)		# luu left vao stack
	sw	$a2, 4($sp)		# luu right vao stack
	sw	$a3, 8($sp)		# luu middle vao stack
	sw	$ra, 12($sp)		# luu return address vao stack
	
	addi	$a2, $a3, 0		# right <- middle

	jal	merge_sort		# goi de quy merge sort tren nua doan (left, middle)
	
	# Tra ve thanh ghi $ra va dung de quy
	# Tiep tuc merge sort tren nua doan con lai
	
	lw	$a1, 0($sp)		# lay left tu stack
	lw	$a2, 4($sp)		# lay right tu stack
	lw	$a3, 8($sp)		# lay middle tu stack
	
	addi 	$a3, $a3, 1
	addi	$a1, $a3, 0		# left <- middle + 1
						
	jal	merge_sort		# goi de quy merge sort tren nua doan (middle + 1, right)	

	# Tra ve thanh ghi $ra va dung de quy
	# Sau do merge 2 array da duoc sap xep lai voi nhau

	lw	$a1, 0($sp)		# lay left tu stack
	lw	$a2, 4($sp)		# lay right tu stack
	lw	$a3, 8($sp)		# lay middle tu stack
	
	jal	merge_array		# goi ham de merge 2 array
	
	lw	$a1, 0($sp)		# lay left tu stack
	lw	$a2, 4($sp)		# lay right tu stack
	lw	$a3, 8($sp)		# lay middle tu stack
	lw	$ra, 12($sp)		# lay return address tu stack
	addi	$sp, $sp, 16		# giai phong 4 o cho stack
	
	stop_sorting:
		jr 	$ra
#--------------------------------------------------------------------------------------------#
merge_array:
# a0 luu mang array
# a1 = left
# a2 = right
# a3 = middle
	la	$t2, arr_temp1			# t2 luu mang phu 1
	la	$t3, arr_temp2			# t3 luu mang phu 2

	sll	$t4, $a1, 2
	add	$t4, $a0, $t4			# t4 luu dia chi cua array[left]
	
	sll	$t5, $a3, 2
	add	$t5, $a0, $t5			# t5 luu dia chi cua array[middle]
 
	initial_arr_temp1:			# Copy mang ban dau array tu vi tri left -> middle sang mang phu arr_temp1
		slt	$s7, $t5, $t4		# s7 = 0 khi left <= middle
						# s7 = 1 khi left > middle (copy xong)
		bne	$s7, $zero, done_arr_temp1
		
		lw	$t9, 0($t4) 		# lay gia tri hien tai cua array
		sw	$t9, 0($t2)		# luu gia tri do vao arr_temp1
	
		addi	$t4, $t4, 4		# tang dia chi cua ca hai len vi tri index ke tiep
		addi	$t2, $t2, 4
		
		j	initial_arr_temp1

		done_arr_temp1:			# thuc hien tuong tu de copy phan con lai
			addi	$s5, $a3, 1	# s5 = middle + 1

			sll	$s5, $s5, 2
			add	$t4, $a0, $s5	# t4 luu dia chi cua array[mid + 1]
	
			sll	$s5, $a2, 2
			add	$t5, $a0, $s5	# t5 luu dia chi cua array[right]
			
	initial_arr_temp2:			# Copy mang ban dau array tu vi tri middle + 1 -> right sang mang phu arr_temp2
		slt	$s7, $t5, $t4		# s7 = 0 khi right >= mid + 1	
						# s7 = 1 khi right < mid + 1 (copy xong)
		bne	$s7, $zero, done_arr_temp2
		
		lw	$t9, 0($t4)		# lay gia tri hien tai cua array
		sw	$t9, 0($t3)		# luu gia tri do vao arr_temp2
		
		addi	$t4, $t4, 4		# tang dia chi cua ca hai len vi tri index ke tiep
		addi	$t3, $t3, 4
		
		j	initial_arr_temp2	
		
		done_arr_temp2:			# da xong viec copy tu mang array ban dau sang 2 mang phu
	
	merge_two_array:					# merge 2 mang phu da duoc sap xep thanh 1 mang duoc sap xep
		sub	$t0, $a3, $a1
		addi	$t0, $t0, 1				# N1 = t0 = middle - left + 1
	
		sub	$t1, $a2, $a3				# N2 = t1 = right - middle
		
		la	$t2, arr_temp1				# t2 luu mang phu 1
		la	$t3, arr_temp2				# t3 luu mang phu 2
	
		addi 	$sp, $sp, -4
		sw	$a0, 0($sp)				# luu dia chi mang ban dau a0 vao trong stack
	
		addi	$t4, $zero, 0				# i = t4 = 0
		addi	$t5, $zero, 0				# j = t5 = 0
	
		sll 	$t6, $a1, 2
		add	$a0, $a0, $t6				#a0 moi luu dia chi cua array[left]
	
		first_loop_to_insert:				# while (i < N1 && j < N2)
			beq	$t0, $t4, first_loop_stop
			beq	$t1, $t5, first_loop_stop
		
			lw	$t6, 0($t2)			# t6 = arr_temp1[i]
			lw	$t7, 0($t3)			# t7 = arr_temp2[j]
			
			slt	$t9, $t7, $t6			# t9 = 1 khi arr_temp2[j] < arr_temp1[i]
								# t9 = 0 khi arr_temp2[j] >= arr_temp1[i]
			bne	$t9, $zero, from_arr_temp2	
			
			sw	$t6, 0($a0)			# Dua phan tu be hon tu arr_temp1 vao array
			addi	$t2, $t2, 4			# tang dia chi arr_temp1 de tiep tuc so sanh
			addi	$t4, $t4, 1			# i <- i + 1
	
			j	continue_insert
	
			from_arr_temp2:				
				sw	$t7, 0($a0)		# Dua phan tu be hon tu arr_temp2 vao array
				addi	$t3, $t3, 4		# tang dia chi arr_temp2 de tiep tuc so sanh
				addi	$t5, $t5, 1		# j <- j + 1
				
			continue_insert:
				addi	$a0, $a0, 4		# tang dia chi array de tiep tuc chen
				j	first_loop_to_insert
			
			first_loop_stop:
			
		second_loop_to_copy_from_arr_temp1:		# while (i < N1)
			beq	$t4, $t0, second_loop_stop
			
			lw	$t6, 0($t2)			# lay gia tri hien tai cua arr_temp1
			sw	$t6, 0($a0)			# luu gia tri do vao array
			
			addi	$t2, $t2, 4			# tang dia chi cua arr_temp1
			addi	$a0, $a0, 4			# tang dia chi cua array
			addi	$t4, $t4, 1			# i <- i + 1
			
			j	second_loop_to_copy_from_arr_temp1
			
			second_loop_stop:
		
		third_loop_to_copy_from_arr_temp2:		# while (j < N2)
			beq	$t1, $t5, third_loop_end
			
			lw	$t6, 0($t3)			# lay gia tri hien tai cua arr_temp2
			sw	$t6, 0($a0)			# luu gia tri do vao array
		
			addi	$t3, $t3, 4			# tang dia chi cua arr_temp2
			addi	$a0, $a0, 4			# tang dia chi cua array
			addi	$t5, $t5, 1			# j <- j + 1
			
			j 	third_loop_to_copy_from_arr_temp2
		
			third_loop_end:
				lw	$a0, 0($sp)		# tra ve mang a0 ban dau
				addi 	$sp, $sp, 4
				
				addi	$sp, $sp, -12
				sw	$a1, 0($sp)		# luu left vao stack
				sw	$a2, 4($sp)		# luu right vao stack
				sw	$ra, 8($sp)		# luu return address vao stack
				add	$a1, $0, $s1		# a1 = s1 = 0
				add	$a2, $0, $s2 		# a2 = s2 = size - 1
				
				jal	print_step_array	# in ra step hien tai
	
				lw	$a1, 0($sp)		# lay left tu stack
				lw	$a2, 4($sp)		# lay right tu stack
				lw	$ra, 8($sp)		# lay return address tu stack
				addi	$sp, $sp, 12	
	
				jr	$ra	
#--------------------------------------------------------------------------------------------#
print_step_array:
# a0 luu mang array
# a1 = left
# a2 = right
	addi 	$sp, $sp, -4
	sw	$a0, 0($sp)					# luu dia chi mang ban dau a0 vao trong stack
	
	addi	$t7, $a1, 0					# t7 = left
	
	sll	$t6, $a1, 2
	add	$t6, $t6, $a0					# t6 luu dia chi cua array[left]
	
	la	$a0, print_step
	addi 	$v0, $zero, 4
	syscall							# in ra "Step "
	
	addi	$v0, $zero, 1
	add	$a0, $zero, $s6
	syscall							# in ra thu tu step
	
	la	$a0, print_colon
	addi 	$v0, $zero, 4
	syscall							# in ra dau hai cham ": "
	
	print_step_array_loop:
		slt	$s4, $a2, $t7				# s4 = 1 khi right < left	
								# t4 = 0 khi right >= left
		bne	$s4, $zero, print_step_array_loop_end	
		
		lw	$a0, 0($t6)				
		addi	$v0, $zero, 1
		syscall						# in ra tung phan tu cua array		
				
		la	$a0, space				# in ra khoang trang " " giua cac so
		addi	$v0, $zero, 4
		syscall
			
		addi	$t6, $t6, 4				# tang dia chi cua array
		addi	$t7, $t7, 1				# left <- left + 1
		
		j	print_step_array_loop
		
	print_step_array_loop_end:				# ket thuc viec in step
		la 	$a0, new_line
		addi 	$v0, $zero, 4
		syscall
		
		addi $s6, $s6, 1				# step <- step + 1
		
		lw	$a0, 0($sp)				# lay lai mang ban dau
		addi 	$sp, $sp, 4
		jr	$ra
#--------------------------------------------------------------------------------------------#
print_initial_array:
	addi  	$v0, $zero, 4				
	la  	$a0, intial_array
	syscall							# In ra "Unsorted Array: "
	
	addi	$t8, $zero, 50					# t8 = size
	addi	$s4, $t8, -1					# s4 = size - 1
	
	addi 	$t0, $zero, 0					# tao mot bien dem count
	la	$t1, array					# t1 luu mang array
	
	print_initial_array_loop:
		slt 	$a1, $t0, $t8				# a1 = 1 khi count < size
								# a1 = 0 khi count >= size
		beq	$a1, $zero, stop_print 
		
		lw 	$t3, 0($t1)				# lay gia tri c?a array hien tai
		addi	$t1, $t1, 4				# tang dia chi cua array
		
		addi 	$v0, $zero, 1
		add 	$a0, $zero, $t3				
		syscall						# in ra cac phan tu cua array
		
   	 	addi  	$v0, $zero, 4				
		la  	$a0, space	
		syscall						# in ra khoang trang " " giua cac so
		
		addi    $t0, $t0, 1				# count <- count + 1
    		j     	print_initial_array_loop
 
	stop_print:
		addi  	$v0, $zero, 4				
		la  	$a0, merge_sorting
		syscall	
		jr 	$ra
#--------------------------------------------------------------------------------------------------------------------------------#
