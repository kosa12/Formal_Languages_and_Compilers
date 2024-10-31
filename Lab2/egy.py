class DFA:
    def __init__(self, allapotok, abece, kezdo_allapot, elfogado_allapotok, atmenetek):
        self.allapotok = allapotok
        self.abece = abece
        self.kezdo_allapot = kezdo_allapot
        self.elfogado_allapotok = elfogado_allapotok
        self.atmenetek = atmenetek   # (allapot, szimbolum) -> kovetkezo_allapot

    def atmenet(self, allapot, szimbolum):  # megadja egy allapot es egy szimbolum alapjan a kovetkezo allapotot
        return self.atmenetek.get((allapot, szimbolum))

    def elfogad(self, bemenet):  # megadja, hogy elfogadja-e az adott bemenetet
        aktualis_allapot = self.kezdo_allapot
        for szimbolum in bemenet:
            aktualis_allapot = self.atmenet(aktualis_allapot, szimbolum)
            if aktualis_allapot is None:
                return False
        return aktualis_allapot in self.elfogado_allapotok


def betolt_dfa_fajlbol(fajlnev):
    with open(fajlnev, 'r') as fajl:
        sorok = fajl.readlines()

    allapotok = set(sorok[0].strip().split())
    abece = set(sorok[1].strip().split())
    kezdo_allapot = sorok[2].strip()
    elfogado_allapotok = set(sorok[3].strip().split())
    atmenetek = {}

    for sor in sorok[4:]:
        allapot, szimbolum, kovetkezo_allapot = sor.strip().split()
        atmenetek[(allapot, szimbolum)] = kovetkezo_allapot

    return DFA(allapotok, abece, kezdo_allapot, elfogado_allapotok, atmenetek)


def ekvivalensek_e(dfa1, dfa2):
    def allapot_parok(dfa1, dfa2):
        return {(dfa1.kezdo_allapot, dfa2.kezdo_allapot)}

    def bfs(dfa1, dfa2):
        latogatott = allapot_parok(dfa1, dfa2)
        sor = [(dfa1.kezdo_allapot, dfa2.kezdo_allapot)]

        while sor:
            allapot1, allapot2 = sor.pop(0)

            if (allapot1 in dfa1.elfogado_allapotok) != (allapot2 in dfa2.elfogado_allapotok):
                return False

            for szimbolum in dfa1.abece.intersection(dfa2.abece):
                kovetkezo_allapot1 = dfa1.atmenet(allapot1, szimbolum)
                kovetkezo_allapot2 = dfa2.atmenet(allapot2, szimbolum)

                if (kovetkezo_allapot1, kovetkezo_allapot2) not in latogatott:
                    latogatott.add((kovetkezo_allapot1, kovetkezo_allapot2))
                    sor.append((kovetkezo_allapot1, kovetkezo_allapot2))

        return True

    return bfs(dfa1, dfa2)


dfa1 = betolt_dfa_fajlbol('form_I.B.1_a1.txt')
dfa2 = betolt_dfa_fajlbol('form_I.B.1_b1.txt')

if ekvivalensek_e(dfa1, dfa2):
    print("Az automaták ekvivalensek.")
else:
    print("Az automaták nem ekvivalensek.")
