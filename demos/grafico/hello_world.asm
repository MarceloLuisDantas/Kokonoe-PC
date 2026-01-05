.text

    la $t1, *hello
    li $t2, 0 # y position on vram
    # li $t3, 0 # x position on vram
    loop:
        lrb $t0, 0($t1) 
        inc $t1

        # if t0 == \0; goto end
        beq $t0, $zero, *end  

        sll $t0, $t0, 8 # t0 = [xxxxxxxx]00000000 character
        
        # t0 = [xxxxxxxx]00000000
        # 16 =          [0001]0000 character color white
        # ------------------------
        # t0 = [xxxxxxxx][0001]0000
        ori $t0, $t0, 16 


        svr $t0, 0($t2) # vram[t2] = $t0
        inc $t2
        
        j *loop
    end:

    li $sc, 100 # render frame

    # Loop infinito
    loop_2:
        syscall
        j *loop_2

    li $sc, 0
    syscall

.data
    hello: .string "Hey guys, did you know that Vaporeon is a Water-type Pokemon introduced in Generation 1? Vaporeon is number 134 in the National Dex, and a member of the Field egg group. It evolves from Eevee when exposed to a Water Stone. Vaporeon has a base stat total of 525, as do all Eeveelutions, and it has the ability Water Absorb. Vaporeon learns various strong moves, such as Aurora Beam, Surf, and Acid Armor. Vaporeon is a blue Pokemon with a quadruped build, weighing in at 64 pounds and standing 1 meter tall. Vaporeon's design is inspired by dogs, foxes, mermaids, dolphins, and fish. Vaporeon is able to hide in water due to its chemical makeup being similar to water, according to various Pokedex entries. Vaporeon is the only Eeveelution in Generation 1 that is not weak to Ground-type attacks. Many Trainers like Vaporeon for its design, which mixes cool and cute, as well as its good stats and movepool. \0"