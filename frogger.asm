#####################################################################
#
# CSC258H5S Fall 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: Uzair Chudhary, 1003894208
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone [1,2,3,4,5] - ALL MILESTONES COMPLETED
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Number of Lives Remaining (Easy)
# 2. Display GameOver/Retry Screen. (Easy)
# 3. Make objects look more like arcade version (Easy)
# 4. Have objects in different rows move at different speeds (Easy)
# 5. Display death/respawn animation (Easy)
# 6. Add a third row in each of water and road sections (Easy;but only added road)
# 7. Display player's score at top of screen
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - Implemented 5 easy features completely and one partially (#6) 
# - Implemented 1 hard feature completely
# - When the frog reaches target and 'NICE' text comes up, click 'C' to continue
# I wrote it like this so the game would sleep then and the text would be visible.
####################################################################

.data
displayAddress: .word 0x10008000
grass: .word 0x228B22
water: .word 0x00BFFF
frog: .word 0x00FF00
logs: .word 0x8B4513
road: .word 0x696969
cars: .word 0x800080
trucks: .word 0xFF4500
beach: .word 0xF4A460
eyes: .word 0x000000

firstLog: .word 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
secondLog: .word 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0
logColourCheck: .word 1

firstCar: .word 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0
secondCar: .word 0, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0
thirdCar: .word 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
carColourCheck: .word 1
truckColourCheck: .word 2

frogX: .word 15
frogY: .word 28

frogLives: .word 3

score: .word 0
.text
j main
main: 
lw $t0, displayAddress # $t0 stores the base address for display

jal drawGoalZone

jal drawWater

jal drawSafeZone

jal drawRoad

jal drawStartZone

jal drawLogs

jal drawCars

jal checkFrogAlive 

jal drawFrog

jal drawFrogLives

jal moveLogs

jal moveCars

jal frogSuccess

jal checkInput

jal drawScore

li $v0, 32
li $a0, 83 # terminate the program gracefully
syscall
j main

drawFrog:
la $t9, ($ra)
lw $t1, frog
lw $t6, frogX #initial is 15
lw $t7, frogY #initial is 28

addi $t6, $t6, -1 #now t6 is 14
addi $a0, $t6, 0
li $a1, 2
addi $t7, $t7, 3 #now t7 is 31
addi $a2, $t7, 0
li $a3, 1
jal rectangle

addi $t6, $t6, 3 #now t6 is 17
addi $a0, $t6, 0
li $a1, 2
addi $a2, $t7, 0 #now t7 is 31
li $a3, 1
jal rectangle

addi $t6, $t6, -2 #now t6 is 15
addi $a0, $t6, 0
li $a1, 3
addi $t7, $t7, -1 #now t7 is 30
addi $a2, $t7, 0
li $a3, 1
jal rectangle

addi $t6, $t6, -1 #now t6 is 14
addi $a0, $t6, 0
li $a1, 1
addi $t7, $t7, -2 #t7 is now 28
addi $a2, $t7, 0
li $a3, 2
jal rectangle

addi $t6, $t6, 2 #now t6 is 16
addi $a0, $t6, 0
li $a1, 1
addi $t7, $t7, 1 #now t7 is 29
addi $a2, $t7, 0
li $a3, 1
jal rectangle

addi $t6, $t6, 2 #now t6 is 18
addi $a0, $t6, 0
li $a1, 1
addi $t7, $t7, -1 #now t7 is 28
addi $a2, $t7, 0
li $a3, 2
jal rectangle

lw $t1, eyes
addi $t6, $t6, -3 #now t6 is 15
addi $a0, $t6, 0
li $a1, 1
addi $t7, $t7, 1 #now t7 is 29
addi $a2, $t7, 0
li $a3, 1
jal rectangle

addi $t6, $t6, 2 #now t6 is 17
addi $a0, $t6, 0
li $a1, 1
addi $a2, $t7, 0
li $a3, 1
jal rectangle

la $ra, ($t9)
jr $ra

rectangle: 
# a0 is left edge x coordinate, a1 is width, a2 is top edge y coordinate, a3 is height
lw $t0, displayAddress
beq $a1, $zero, rectangleReturn
beq $a3, $zero, rectangleReturn

add $a1, $a1, $a0  #simplify loop condition
add $a3, $a3, $a2

sll $a0, $a0, 2 #scale x values to bytes (4 bytes per pixel)
sll $a1, $a1, 2

sll $a2, $a2, 7 #scale y value to bytes (log of 32 * 4 bytes per row)
sll $a3, $a3, 7

addu $t2, $a2, $t0 #y values to starting row starting addresses
addu $a3, $a3, $t0

addu $a2, $t2, $a0 #rectangle row starting addresses
addu $a3, $a3, $a0

addu $t2, $t2, $a1 #find ending address for first row

li $t4, 0x80 #bytes per row (4 * 256)

rectangleYLoop: 
move $t3, $a2 #start at left side

rectangleXLoop: 
sw $t1,($t3)
addiu $t3, $t3, 4 #move 4 bytes

bne $t3, $t2, rectangleXLoop #keep going if it hasnt reached the right side of the rectangle

addu $a2, $a2, $t4 #move to next row
addu $t2, $t2, $t4 #change right pointer
bne $a2, $a3, rectangleYLoop #keep going if it hasnt reached the bottom rectangle

rectangleReturn:
jr $ra

drawGoalZone:
la $t9, ($ra)
lw $t1, grass
li $a0, 0 #left x coordinate
li $a1, 32 #right x coordinate (width)
li $a2, 0 #top y coordinate
li $a3, 4 #height
jal rectangle # call rectangle function
la $ra, ($t9)
jr $ra

drawWater:
la $t9, ($ra)
lw $t1, water
li $a0, 0
li $a1, 32
li $a2, 4
li $a3, 8
jal rectangle
la $ra, ($t9)
jr $ra

drawSafeZone:
la $t9, ($ra)
lw $t1, beach
li $a0, 0
li $a1, 32
li $a2, 12
li $a3, 4
jal rectangle
la $ra, ($t9)
jr $ra

drawRoad:
la $t9, ($ra)
lw $t1, road
li $a0, 0
li $a1, 32
li $a2, 16
li $a3, 12
jal rectangle
la $ra, ($t9)
jr $ra

drawStartZone:
la $t9, ($ra)
lw $t1, grass
li $a0, 0
li $a1, 32
li $a2, 28
li $a3, 4
jal rectangle
la $ra, ($t9)
jr $ra

drawLogs:
lw $t8, displayAddress
addi $t8, $t8, 512 #position being colored
la $t5, firstLog #array of top log positions
add $t0, $zero, $zero # i = 0
add $t1, $zero, 128 # beginning position of next row
add $t2, $zero, $zero #row increment
addi $t3, $zero, 4 #row maximum

lw $t6, logColourCheck #check for 1 in array
lw $t7, logs #log color


logLoop1:
beq $t2, $t3, continue
beq $t0, $t1, logRowComplete1

lw $t9, ($t5)
beq $t9, $t6, paintLog1

addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j logLoop1

paintLog1:
sw $t7, ($t8)
addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j logLoop1

logRowComplete1:
addi $t2, $t2, 1
add $t0, $zero, $zero
la $t5, firstLog
j logLoop1

continue:
lw $t8, displayAddress
addi $t8, $t8, 1024 #position being colored
la $t5, secondLog #array of top log positions
add $t0, $zero, $zero # i = 0
add $t1, $zero, 128 # beginning position of next row
add $t2, $zero, $zero #row increment
addi $t3, $zero, 4 #row maximum

lw $t6, logColourCheck #check for 1 in array
lw $t7, logs #log color


logLoop2:
beq $t2, $t3, exitDrawLog
beq $t0, $t1, logRowComplete2

lw $t9, ($t5)
beq $t9, $t6, paintLog2

addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j logLoop2

paintLog2:
sw $t7, ($t8)
addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j logLoop2

logRowComplete2:
addi $t2, $t2, 1
add $t0, $zero, $zero
la $t5, secondLog
j logLoop2


exitDrawLog:
jr $ra



drawCars:
lw $t8, displayAddress
addi $t8, $t8, 2048 #position being colored
la $t5, firstCar #array of first car positions
add $t0, $zero, $zero # i = 0
add $t1, $zero, 128 # beginning position of next row
add $t2, $zero, $zero #row increment
addi $t3, $zero, 4 #row maximum

lw $t4, truckColourCheck #check for 2 in array
lw $t6, carColourCheck #check for 1 in array

carLoop1:
beq $t2, $t3, continueCar
beq $t0, $t1, carRowComplete1

lw $t9, ($t5)
beq $t9, $t6, paintCar1
beq $t9, $t4, paintTruck1

addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j carLoop1

paintCar1:
lw $t7, cars #car color
sw $t7, ($t8)
addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j carLoop1

paintTruck1:
lw $t7, trucks #truck color
sw $t7, ($t8)
addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j carLoop1

carRowComplete1:
addi $t2, $t2, 1
add $t0, $zero, $zero
la $t5, firstCar
j carLoop1

continueCar: 
lw $t8, displayAddress
addi $t8, $t8, 2560 #position being colored
la $t5, secondCar #array of first car positions
add $t0, $zero, $zero # i = 0
add $t1, $zero, 128 # beginning position of next row
add $t2, $zero, $zero #row increment
addi $t3, $zero, 4 #row maximum

lw $t4, truckColourCheck #check for 2 in array

carLoop2:
beq $t2, $t3, continueCar2
beq $t0, $t1, carRowComplete2

lw $t9, ($t5)
beq $t9, $t4, paintTruck2

addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j carLoop2

paintTruck2:
lw $t7, trucks #truck color
sw $t7, ($t8)
addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j carLoop2

carRowComplete2:
addi $t2, $t2, 1
add $t0, $zero, $zero
la $t5, secondCar
j carLoop2

continueCar2:
lw $t8, displayAddress
addi $t8, $t8, 3072 #position being colored
la $t5, thirdCar #array of first car positions
add $t0, $zero, $zero # i = 0
add $t1, $zero, 128 # beginning position of next row
add $t2, $zero, $zero #row increment
addi $t3, $zero, 4 #row maximum

lw $t6, carColourCheck #check for 1 in array

carLoop3:
beq $t2, $t3, exitDrawCar
beq $t0, $t1, carRowComplete3

lw $t9, ($t5)
beq $t9, $t6, paintCar2

addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j carLoop3

paintCar2:
lw $t7, cars #truck color
sw $t7, ($t8)
addi $t0, $t0, 4
addi $t8, $t8, 4
addi $t5, $t5, 4
j carLoop3

carRowComplete3:
addi $t2, $t2, 1
add $t0, $zero, $zero
la $t5, thirdCar
j carLoop3

exitDrawCar:
jr $ra

checkFrogAlive:
lw $t0, displayAddress
lw $t1, frogX
lw $t2, frogY

sll $t1, $t1, 2
sll $t2, $t2, 7

add $t0, $t0, $t1
add $t0, $t0, $t2
addi $t0, $t0, -4

lw $t3, ($t0)

lw $t4, cars
lw $t5, trucks
lw $t6, water

beq $t3, $t4, deadFrog
beq $t3, $t5, deadFrog

addi $t0, $t0, 20
lw $t3, ($t0)

beq $t3, $t4, deadFrog
beq $t3, $t5, deadFrog

beq $t3, $t6, checkLeftWater

jr $ra

checkLeftWater:
addi $t0, $t0, -20
lw $t3, ($t0)
beq $t3, $t6, deadFrog
jr $ra


deadFrog:
la $t9, ($ra)
#add animation or sounds
drawDeadFrog:
lw $t1, trucks
lw $t6, frogX #initial is 15
lw $t7, frogY #initial is 28

addi $t6, $t6, -1 #now t6 is 14
addi $a0, $t6, 0
li $a1, 2
addi $t7, $t7, 3 #now t7 is 31
addi $a2, $t7, 0
li $a3, 1
jal rectangle

addi $t6, $t6, 3 #now t6 is 17
addi $a0, $t6, 0
li $a1, 2
addi $a2, $t7, 0 #now t7 is 31
li $a3, 1
jal rectangle

addi $t6, $t6, -2 #now t6 is 15
addi $a0, $t6, 0
li $a1, 3
addi $t7, $t7, -1 #now t7 is 30
addi $a2, $t7, 0
li $a3, 1
jal rectangle

addi $t6, $t6, -1 #now t6 is 14
addi $a0, $t6, 0
li $a1, 1
addi $t7, $t7, -2 #t7 is now 28
addi $a2, $t7, 0
li $a3, 2
jal rectangle

addi $t6, $t6, 2 #now t6 is 16
addi $a0, $t6, 0
li $a1, 1
addi $t7, $t7, 1 #now t7 is 29
addi $a2, $t7, 0
li $a3, 1
jal rectangle

addi $t6, $t6, 2 #now t6 is 18
addi $a0, $t6, 0
li $a1, 1
addi $t7, $t7, -1 #now t7 is 28
addi $a2, $t7, 0
li $a3, 2
jal rectangle

lw $t1, eyes
addi $t6, $t6, -3 #now t6 is 15
addi $a0, $t6, 0
li $a1, 1
addi $t7, $t7, 1 #now t7 is 29
addi $a2, $t7, 0
li $a3, 1
jal rectangle

addi $t6, $t6, 2 #now t6 is 17
addi $a0, $t6, 0
li $a1, 1
addi $a2, $t7, 0
li $a3, 1
jal rectangle

la $t0, frogX
la $t1, frogY

add $t2, $zero, 15
sw $t2, ($t0)

add $t3, $zero, 28
sw $t3, ($t1)

#li $v0, 32
#li $a0, 1000 # terminate the program gracefully
#syscall

j reduceLife

reduceLife:
la $t0, frogLives
lw $t1, frogLives

addi $t1, $t1, -1
sw $t1, ($t0)

beqz $t1, gameOver

la $ra, ($t9)
jr $ra

gameOver:
#display Game over text
drawGameOver:
lw $t1, displayAddress
lw $t2, eyes

sw $t2, ($t1)  #G
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 128($t1)
sw $t2, 256($t1)
sw $t2, 264($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)
sw $t2, 392($t1)

addi $t1, $t1, 16
sw $t2, ($t1) #A
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 128($t1)
sw $t2, 136($t1)
sw $t2, 256($t1)
sw $t2, 260($t1)
sw $t2, 264($t1)
sw $t2, 384($t1)
sw $t2, 392($t1)

addi $t1, $t1, 16
sw $t2, ($t1) #M
sw $t2, 16($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 140($t1)
sw $t2, 144($t1)
sw $t2, 256($t1)
sw $t2, 264($t1)
sw $t2, 272($t1)
sw $t2, 384($t1)
sw $t2, 400($t1)

addi $t1, $t1, 24
sw $t2, ($t1) #E
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 12($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)
sw $t2, 392($t1)
sw $t2, 396($t1)

lw $t1, displayAddress
addi $t1, $t1, 512

sw $t2, ($t1) #O
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 12($t1)
sw $t2, 128($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 268($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)
sw $t2, 392($t1)
sw $t2, 396($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #V
sw $t2, 12($t1)
sw $t2, 128($t1)
sw $t2, 140($t1)
sw $t2, 260($t1)
sw $t2, 264($t1)
sw $t2, 388($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #E
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 12($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)
sw $t2, 392($t1)
sw $t2, 396($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #R
sw $t2, 8($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)


lw $t1, displayAddress
addi $t1, $t1, 1536

sw $t2, ($t1) #[
sw $t2, 4($t1)
sw $t2, 128($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)

addi $t1, $t1, 12
sw $t2, ($t1) #R
sw $t2, 8($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #]
sw $t2, 4($t1)
sw $t2, 132($t1)
sw $t2, 260($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)

addi $t1, $t1, 12
sw $t2, ($t1) #E
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 12($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)
sw $t2, 392($t1)
sw $t2, 396($t1)

addi $t1, $t1, 20
sw $t2, 4($t1) #T
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 260($t1)
sw $t2, 388($t1)

addi $t1, $t1, 16
sw $t2, ($t1) #R
sw $t2, 8($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #Y
sw $t2, 12($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 260($t1)
sw $t2, 384($t1)

checkRetry:
lw $t8, 0xffff0000
beq $t8, 1, checkR

j drawGameOver

checkR:
lw $t8, 0xffff0004
beq $t8, 0x72, restartGame
j drawGameOver

restartGame:
la $t0, frogX
la $t1, frogY

add $t2, $zero, 15
sw $t2, ($t0)

add $t3, $zero, 28
sw $t3, ($t1)

la $t4, score
add $t5, $zero, $zero
sw $t5, ($t4)

la $t6, frogLives
add $t7, $zero, 3
sw $t7, ($t6)

la $ra, ($t9)
jr $ra

moveLogs:
la $t9, ($ra)
la $t0, firstLog
jal shiftArrayRight
jal shiftArrayRight

la $t0, secondLog
jal shiftArrayLeft

la $ra, ($t9)
jr $ra

moveCars:
la $t9, ($ra)
la $t0, firstCar
jal shiftArrayRight
jal shiftArrayRight

la $t0, secondCar
jal shiftArrayLeft

la $t0, thirdCar
jal shiftArrayRight

la $ra, ($t9)
jr $ra

shiftArrayRight:
add $t3, $t0, 124
lw $t8, ($t3)

add $s0, $zero, 30

rightLoop:
blt $s0, $zero, breakRightLoop
lw $t1, -4($t3)
sw $t1, ($t3)

subi $s0, $s0, 1
subi $t3, $t3, 4
j rightLoop

breakRightLoop:
sw $t8, ($t3)

jr $ra


shiftArrayLeft:
add $t3, $t0, $zero
lw $t8, ($t3)

add $s0, $zero, $zero

leftLoop:
bgt $s0, 30, breakLeftLoop
lw $t1, 4($t3)
sw $t1, ($t3)

addi $s0, $s0, 1
addi $t3, $t3, 4
j leftLoop

breakLeftLoop:
sw $t8, ($t3)

jr $ra
 
frogSuccess:
lw $t0, frogY
add $t1, $zero, $zero
addi $t1, $t1, 4

blt $t0, $t1, reachedTarget
jr $ra

reachedTarget:
la $t2, score
lw $t4, score
add $t3, $zero, $zero
add $t3, $t3, $t4
addi $t3, $t3, 1
sw $t3, ($t2)

beq $t3, 5, winner

drawNice:
lw $t2, displayAddress
addi $t2, $t2, 1556

lw $t3, eyes
sw $t3, ($t2) #N
sw $t3, 128($t2)
sw $t3, 132($t2)
sw $t3, 256($t2)
sw $t3, 264($t2)
sw $t3, 384($t2)
addi $t2, $t2, 12
sw $t3, ($t2) 
sw $t3, 128($t2)
sw $t3, 256($t2)
sw $t3, 384($t2)

addi $t2, $t2, 8
sw $t3, ($t2) #I
sw $t3, 128($t2)
sw $t3, 256($t2)
sw $t3, 384($t2)

addi $t2, $t2, 8
sw $t3, ($t2) #C
sw $t3, 4($t2)
sw $t3, 8($t2)
sw $t3, 128($t2)
sw $t3, 256($t2)
sw $t3, 384($t2)
sw $t3, 388($t2)
sw $t3, 392 ($t2)

addi $t2, $t2, 16
sw $t3, ($t2) #E
sw $t3, 4($t2)
sw $t3, 8($t2)
sw $t3, 128($t2)
sw $t3, 132($t2)
sw $t3, 136($t2)
sw $t3, 256($t2)
sw $t3, 384($t2)
sw $t3, 388($t2)
sw $t3, 392($t2)

checkContinue:
lw $t8, 0xffff0000
beq $t8, 1, checkC

j drawNice

checkC:
lw $t8, 0xffff0004
beq $t8, 0x63, continueGame
j drawNice

continueGame:
addi $t3, $t3, 1
sw $t3, ($t2)

add $t4, $zero, $zero
addi $t4, $t4, 28
la $t0, frogY
sw $t4, ($t0)

la $t5, frogX
add $t6, $zero, $zero
addi $t6, $t6, 15
sw $t6, ($t5)

jr $ra

checkInput:
lw $t8, 0xffff0000
beq $t8, 1, keyboard_input
jr $ra

keyboard_input:
lw $t2, 0xffff0004
beq $t2, 0x61, respond_to_A
beq $t2, 0x73, respond_to_S
beq $t2, 0x64, respond_to_D
beq $t2, 0x77, respond_to_W
jr $ra

respond_to_A:
la $t0, frogX
lw $t1, ($t0)

add $t3, $zero, 4
blt $t1, $t3, exitA
addi $t1, $t1, -4
sw $t1, ($t0)

exitA: 
jr $ra

respond_to_S:
la $t0, frogY
lw $t1, ($t0)

add $t3, $zero, 28
bge $t1, $t3, exitS
addi $t1, $t1, 4
sw $t1, ($t0)

exitS: 
jr $ra

respond_to_D:
la $t0, frogX
lw $t1, ($t0)

add $t3, $zero, 27
bge $t1, $t3, exitD
addi $t1, $t1, 4
sw $t1, ($t0)

exitD: 
jr $ra

respond_to_W:
la $t0, frogY
lw $t1, ($t0)

add $t3, $zero, 4
blt $t1, $t3, exitW
addi $t1, $t1, -4
sw $t1, ($t0)

exitW: 
jr $ra

drawFrogLives:
lw $t0, frogLives
add $t1, $zero, $zero
lw $t2, displayAddress
lw $t3, cars

drawFrogLivesLoop:
beq $t1, $t0, exitDrawFrogLives
sw $t3, ($t2)
addi $t1, $t1, 1
addi $t2, $t2, 8
j drawFrogLivesLoop

exitDrawFrogLives:
jr $ra

winner:
lw $t1, displayAddress
lw $t2, eyes

sw $t2, ($t1) #Y
sw $t2, 12($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 260($t1)
sw $t2, 384($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #O
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 12($t1)
sw $t2, 128($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 268($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)
sw $t2, 392($t1)
sw $t2, 396($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #U
sw $t2, 12($t1)
sw $t2, 128($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 268($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)
sw $t2, 392($t1)
sw $t2, 396($t1)

addi $t1, $t1, 24
sw $t2, ($t1) #W
sw $t2, 16($t1)
sw $t2, 128($t1)
sw $t2, 136($t1)
sw $t2, 144($t1)
sw $t2, 256($t1)
sw $t2, 260($t1)
sw $t2, 268($t1)
sw $t2, 272($t1)
sw $t2, 384($t1)
sw $t2, 400($t1)

addi $t1, $t1, 24
sw $t2, ($t1) #I
sw $t2, 128($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)

addi $t1, $t1, 8
sw $t2, ($t1) #N
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 256($t1)
sw $t2, 264($t1)
sw $t2, 384($t1)
addi $t1, $t1, 12
sw $t2, ($t1) 
sw $t2, 128($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)

addi $t1, $t1, 8
sw $t2, ($t1) #!
sw $t2, 128($t1)
sw $t2, 384($t1)

lw $t1, displayAddress
addi $t1, $t1, 1536

sw $t2, ($t1) #[
sw $t2, 4($t1)
sw $t2, 128($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)

addi $t1, $t1, 12
sw $t2, ($t1) #R
sw $t2, 8($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #]
sw $t2, 4($t1)
sw $t2, 132($t1)
sw $t2, 260($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)

addi $t1, $t1, 12
sw $t2, ($t1) #E
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 12($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)
sw $t2, 388($t1)
sw $t2, 392($t1)
sw $t2, 396($t1)

addi $t1, $t1, 20
sw $t2, 4($t1) #T
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 260($t1)
sw $t2, 388($t1)

addi $t1, $t1, 16
sw $t2, ($t1) #R
sw $t2, 8($t1)
sw $t2, 128($t1)
sw $t2, 132($t1)
sw $t2, 140($t1)
sw $t2, 256($t1)
sw $t2, 384($t1)

addi $t1, $t1, 20
sw $t2, ($t1) #Y
sw $t2, 12($t1)
sw $t2, 132($t1)
sw $t2, 136($t1)
sw $t2, 260($t1)
sw $t2, 384($t1)

checkWinnerRetry:
lw $t8, 0xffff0000
beq $t8, 1, checkWinR

j winner

checkWinR:
lw $t8, 0xffff0004
beq $t8, 0x72, restartGame
j winner


drawScore:
lw $t0, score
add $t1, $zero, $zero
lw $t2, eyes
lw $t3, displayAddress
addi $t3, $t3, 92

drawScoreLoop:
beq $t0, $t1, endDrawScore
sw $t2, ($t3)
sw $t2, 128($t3)
sw $t2, 256($t3)
sw $t2, 384($t3)
addi $t1, $t1, 1
addi $t3, $t3, 8
j drawScoreLoop

endDrawScore: 
jr $ra
