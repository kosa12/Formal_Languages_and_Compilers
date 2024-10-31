#Kosa Matyas
#532
#I.A.1

def automata_kodolas(in_file_nev):
    with open(in_file_nev) as f:
        sorok = f.readlines()

    dot_kod = """
digraph G{
    ranksep = 0.5;
    nodesep = 0.5;
    rankdir = LR;
    node [shape = "circle", fontsize = "16"];
    fontsize = "10";
    compound = true;
"""

    kezdo = sorok[2].split()
    vege = sorok[3].split()

    for kezd in kezdo:
        dot_kod += f"i{kezd} [shape = point, style = invis];\n"
    for veg in vege:
        dot_kod += f"{veg} [shape = doublecircle];\n"

    dot_kod += "\n"

    for kezd in kezdo:
        dot_kod += f"i{kezd} -> {kezd};\n"

    dot_kod += "\n"

    el_lista = {}
    for sor in sorok[4:]:
        kezdo_pont = sor[0]
        veg_pont = sor[4]
        cimke = sor[2]

        kulcs = (kezdo_pont, veg_pont)
        if kulcs in el_lista:
            el_lista[kulcs].append(cimke)
        else:
            el_lista[kulcs] = [cimke]

    for (kezdo_pont, veg_pont), cimkek in el_lista.items():
        cimkek_str = ",".join(cimkek)
        dot_kod += f"{kezdo_pont} -> {veg_pont} [label = \"{cimkek_str}\"];\n"

    dot_kod += "}\n"
    return dot_kod


def main():
    in_file_nev = "form_I.A.1.txt"
    out_file_nev = "output_I.A.1.txt"
    megoldas = automata_kodolas(in_file_nev)

    with open(out_file_nev, "w") as f:
        f.write(megoldas)


if __name__ == "__main__":
    main()
