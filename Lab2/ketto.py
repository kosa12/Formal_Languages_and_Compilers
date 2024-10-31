class VeremAutomata:
    def __init__(self, allapotok, bemeneti_abece, verem_abece, kezdo_allapot, verem_kezdojel, vegallapotok, atmenetek):
        self.allapotok = allapotok
        self.bemeneti_abece = bemeneti_abece
        self.verem_abece = verem_abece
        self.kezdo_allapot = kezdo_allapot
        self.verem_kezdojel = verem_kezdojel
        self.vegallapotok = set(vegallapotok)
        self.atmenetek = atmenetek

    def elfogadja(self, szo): # megadja, hogy elfogadja-e az adott szót
        kezdo_verem = [self.verem_kezdojel]
        konfiguraciok = [(self.kezdo_allapot, szo, kezdo_verem)]

        while konfiguraciok:
            aktualis_allapot, maradek_szo, aktualis_verem = konfiguraciok.pop()

            if not maradek_szo and (aktualis_allapot in self.vegallapotok or not aktualis_verem):
                return True

            # Következő karakter a bemenetből, ha van ilyen
            kovetkezo_karakter = maradek_szo[0] if maradek_szo else None
            verem_teteje = aktualis_verem[-1] if aktualis_verem else None

            # Lehetséges átmenetek lekérdezése a jelenlegi állapottal, bemeneti szimbólummal és verem tetejével
            lehetseges_atmenetek = self.atmenetek.get((aktualis_allapot, kovetkezo_karakter, verem_teteje), []) \
                                   + self.atmenetek.get((aktualis_allapot, None, verem_teteje), [])
            for uj_allapot, uj_verem_szimbolumok in lehetseges_atmenetek:
                # Frissítjük a verem tartalmát az átmenet alapján
                uj_verem = aktualis_verem[:-1] + (uj_verem_szimbolumok if uj_verem_szimbolumok != ["eps"] else [])
                konfiguraciok.append((uj_allapot, maradek_szo[1:] if kovetkezo_karakter else maradek_szo, uj_verem))

        return False

def automata_betoltes(fajlnev):
    with open(fajlnev, 'r') as f:
        sorok = f.read().strip().splitlines()

    allapotok = sorok[0].split()
    bemeneti_abece = sorok[1].split()
    verem_abece = sorok[2].split()
    kezdo_allapot = sorok[3].strip()
    verem_kezdojel = sorok[4].strip()
    vegallapotok = sorok[5].split()

    atmenetek = {}
    for sor in sorok[6:]:
        elemek = sor.split()
        aktualis_allapot, bemeneti_szimbolum, verem_szimbolum = elemek[0], elemek[1], elemek[2]
        uj_verem_szimbolumok = elemek[3:-1] if elemek[3] != "eps" else ["eps"]
        uj_allapot = elemek[-1]

        kulcs = (aktualis_allapot, bemeneti_szimbolum if bemeneti_szimbolum != 'eps' else None, verem_szimbolum)
        if kulcs not in atmenetek:
            atmenetek[kulcs] = []
        atmenetek[kulcs].append((uj_allapot, uj_verem_szimbolumok))

    return VeremAutomata(allapotok, bemeneti_abece, verem_abece, kezdo_allapot, verem_kezdojel, vegallapotok, atmenetek)

def szavak_feldolgozasa(automata, szavak_fajlnev):
    with open(szavak_fajlnev, 'r') as f:
        szavak = f.read().strip().splitlines()

    eredmenyek = {}
    for szo in szavak:
        eredmenyek[szo] = automata.elfogadja(szo)

    return eredmenyek

automata = automata_betoltes("form_I.B.2_b.txt")
eredmenyek = szavak_feldolgozasa(automata, "form_I.B.2_b_szavak.txt")

for szo, elfogadott in eredmenyek.items():
    print(f"{szo}: {'Elfogadott' if elfogadott else 'Elutasított'}")
