#Kosa Matyas
#532
#I.A.2


def parseolas(filename):
    with open(filename) as f:
        sorok = f.readlines()

    megoldas = []
    for i, sor in enumerate(sorok):
        sor = sor.strip()
        if i == 0:
            megoldas.append(sor + " VEG")
        elif i in (1, 2):
            megoldas.append(sor)
        elif i == 3:
            megoldas.append("VEG")
            megoldas.append(sor)
        else:
            chars = sor.split()
            if len(chars) == 2:
                megoldas.append(sor + " VEG")
            else:
                megoldas.append(sor)

    return "\n".join(megoldas) + "\n"


def main():
    in_file_nev = "form_I.A.2.txt"
    out_file_nev = "output_I.A.2.txt"
    eredmeny = parseolas(in_file_nev)

    with open(out_file_nev, "w") as f:
        f.write(eredmeny)


if __name__ == "__main__":
    main()
