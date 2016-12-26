F1 = open("pokeprism.gbc", "rb")
F2 = open("pokeprism00.gbc", "rb")
bank_diff = 0x4000
num_banks = 0x80
bank_ends = []
bank_space = []
for bank in range(num_banks):
    empty_bank = True
    for i in range(bank_diff):
        F1.seek((bank + 1) * bank_diff - i - 1)
        F2.seek((bank + 1) * bank_diff - i - 1)
        if F1.read(1) == F2.read(1):
            bank_space.append(i)
            bank_ends.append(bank_diff * (1 + (bank != 0)) - i)
            empty_bank = False
            break
    if empty_bank:
        bank_space.append(bank_diff)
        bank_ends.append(bank_diff)
F1.close()
F2.close()

for bank, end, space in zip(range(num_banks), bank_ends, bank_space):
    print("Bank ${:02x}: ${:04x} (${:04x})".format(bank, end, space))
print("")

free_banks = sorted(range(num_banks), key = bank_space.__getitem__, reverse = True)
for bank in free_banks:
    space = bank_space[bank]
    print("Bank ${:02x} has ${:04x} bytes of free space".format(bank, space))
print("")

total_size = bank_diff * num_banks
free_space = sum(bank_space)
pct_free = free_space * 100 / total_size
print("Free space: {:d}/{:d} ({:d}%)".format(free_space, total_size, pct_free))
