---
layout: post
title:  "Tutorial Vagrant"
date:   2015-07-23 20:--:00
author: "Sabin Marcu & Elena Pistol"
categories: tutorial
---


În ultimii ani, virtualizarea și standardizarea mașinilor virtuale a devenit un subiect din ce în ce mai dezbătut, și populat de diferite sisteme ce își doresc a face acest subiect o realitate cât mai accesibilă. Unul dintre aceste sisteme, realizat modular, este **Vagrant**. În următoarele rânduri vom vorbi despre ce este mai exact Vagrant, cum funcționează și cum se instaleaza și configurează acest sistem.

### Ce este Vagrant?

Dacă veți căuta pe Google **Vagrant**, veți obține aproximativ următoarea definiție:

![Imagine definiție vagrant](/assets/images/vagrant/def.png)

Vagrant este definit ca `o persoană fără un cămin stabilit sau job stabil ce se mută din loc în loc`. Într-un fel, această descriere se potrivește destul de bine software-ului *Vagrant*.

Software-ul Vagrant este un sistem de configurare, distribuție și virtualizare a mediilor de lucru, dezvoltare și publicare. El permite, prin o mulțime de aplicații externe, configurarea, aprovizionarea și distribuirea ușoară a mașinilor virtuale, cu scopul de a standardiza și ușura pregătirea unui mediu pentru dezvoltarea sau publicarea unei aplicații, sau a obține accesul la unelte necesare lucrului disponibile doar pe anumite sisteme de operare.

Un exemplu concret ar fi izolarea mediilor de dezvoltare, și automatizare compilări și creării aplicațiilor pe medii diferite (Ex: Windows pentru aplicații Windows Phone, Mac OS X pentru aplicații iOS, etc). Un alt exemplu ar fi experimentarea fără a polua mașina locală, sau izolarea experimentelor între ele.

Acest proces este descris într-un singur fișier ce poate fi copiat din loc în loc, creând mediul dorit pe orice mașină gazdă (fie fizică, fie virtuală). Mediul creat poate fi atunci modificat în orice mod, iar când este creat din nou, va reveni la starea inițială definită în fișier.

Vagrant nu este o persoană, dar poate călători din loc în loc, fără un cămin anume sau job stabil. Este o soluție pentru omogenizarea mediului de lucru între membrii unei echipe de development, a publicării în paralel a unui software, sau oricărei alte acțiuni ce necesită un punct de plecare predefinit. Vagrant oferă acest punct de plecare într-un mod minimalist și sigură.

### Cum funcționează Vagrant?

Vagrant este un sistem de gestionare și configurare a mașinilor virtuale create de către diferite sisteme de virtualizare (VirtualBox, VMWare, Docker, etc).

Vagrant utilizează o mulțime de **mașini virtuale pre-definite** pentru diferite sisteme de operare (Ex: Windows, Ubuntu, Mac OS X, Red Hat, etc.) și diferite versiuni ale acestor sisteme. Vagrant va descărca aceste mașini virtuale pre-definite dorite, și va crea copii ale lor când este nevoie. Aceste mașini de obicei sunt create minimalist, cu un numar minim de utilitare și configurații realizate, pentru a se potrivi unei game cât mai largi de cerințe.

Din acest moment, mașina virtuală copiată va fi **aprovizionată**. Aprovizionarea (sau *Provisioning-ul*) mașinii se realizează prin mai multe moduri, descrise mai jos, scopul fiind pregătirea mașinii pentru lucru, fie prin instalarea soft-urilor necesare, pornirea unor servicii, fie prin legarea elementelor din mașina virtuală cu cele din mașina gazdă (cea care reulează mașina virtuală) precum rețea sau fișiere și foldere.

După ce crearea mașinii virtuale este terminată, ea poate fi pornită. În acest moment se rulează aprovizionarea. Când aprovizionarea este terminată, mașina poate fi accesată fie prin SSH, fie prin alte metode (Ex: pentru VirtualBox, VMWare, etc. mașina poate fi accesată din iterfață serviciului).

Informațiile necesare creeri și aprovizionării unei astfel de mașini sunt stocate într-un fișier numit *Vagrantfile*. Acest fișier poate fi pur și simplu transferat pe o altă mașină (fizică sau virtuală) de unde tot procesul poate fi reluat fără nici o modificare, fără a necesita decât prezența utilitarului Vagrant și a provider-ului (VirtualBox, VMWare, etc).

## Instalare

Înainte de a începe instalarea **Vagrant** trebuie să ne asigurăm că Vagrant va avea un sistem de mașini virtuale pe care îl va putea folosi. Vagrant suportă un numar de astfel de sisteme printre care și: *VirtualBox*, *VMWare*, *Docker*, *Hyper-V*, etc. Conexiunea pentru aceste sisteme se realizează prin plugin-uri numite *Provideri*. Vagrant vine pre-instalat cu suport pentru *VirtualBox*, iar suportul pentru alte platforme (platforme care de obicei necesită licență plătită) este de obicei oferit contra-cost.

Prin urmare, vom folosi **VirtualBox** pentru a lucra cu Vagrant, iar înainte de a instala / folosi Vagrant, trebuie să ne asigurăm că *VirtualBox* este instalat. Pentru a instala VirtualBox, va trebui să accesați [pagina de descărcare](https://www.virtualbox.org/wiki/Downloads) și să descărcați și instalați versiunea potrivită sistemului de operare folosit.

{% comment %}

Link catre un tutorial VirtualBox

{% endcomment %}

### Linux (Ubuntu)

Pentru scopul acestui tutorial se va folosi o instalare de **Ubuntu** deoarece este cea mai populară / folosită distribuție de *linux* la momentul actual. Procedeul de instalare pentru alte distribuții este similar.

Primul pas spre a instala Vagrant pe o mașină Ubuntu / Linux este a descărca pachetul de instalare _.deb_ (ultima versiune disponibilă la data creări articolului este **vagrant_1.7.3**). Pachetul va trebui ales și în funcție de arhitectura sistemului de operare, fie *32 de biți*, fie *64 de biți*. Dacă nu sunteți siguri, folosiți varianta pe *32 de biți*. Aceasta imagine este disponibilă la [adresa de descărcare a site-ului](http://www.vagrantup.com/downloads.html) Vagrant, ilustrată in imaginea de mai jos:
[![Imagine pagină de descărcare](/assets/images/vagrant/ubuntu/website.png)](/assets/images/vagrant/ubuntu/website.png)

După ce pachetul este descărcat, rulați fișierul fie din meniul / fereastra de download a browser-ului, fie din *File Explorer* (Nautilus în cazul Ubuntu). La deschiderea fișierului o fereastră asemănătoare cu cea de mai jos se va deschide, pentru a iniția procesul de instalare. Utilizatorul va trebui să urmărească un fir standard de execuție, prin a apăsa butonul de instalare. La un moment dat, utilizatorul va fi solicitat să introducă parola sa pentru a putea efectua instalarea. Procesul este ilustrat în imaginile de mai jos:

[![Imagine fereastră de instalare](/assets/images/vagrant/ubuntu/installwindow.png)](/assets/images/vagrant/ubuntu/installwindow.png)
[![Imagine fereastră de autentificare](/assets/images/vagrant/ubuntu/pass.png)](/assets/images/vagrant/ubuntu/pass.png)

La sfârșitul instalării, fereastra inițială va afișa faptul că pachetul este instalat, într-o manieră similară ca cea prezentată mai jos:

[![Imagine fereastră de instalare finalizata](/assets/images/vagrant/ubuntu/finishedinstall.png)](/assets/images/vagrant/ubuntu/finishedinstall.png)

într-un final, utilizatorul poate verifica dacă Vagrant a fost instalat pentru a deschide un emulator de terminal (Ubuntu: aplicația Terminal. Nota: Aplicația terminal poate fi pornit într-un instalare tipică de Ubuntu prin combinația de taste **`Control` + `Alt` + `T`**) și introducerea comenzii :

`bash
$ vagrant --help
`

sau

`bash
$ vagrant --version
`

Exemplu:

[![Imagine ajutor vagrant](/assets/images/vagrant/ubuntu/vagranthelp.png)](/assets/images/vagrant/ubuntu/vagranthelp.png)



### Mac OS X

Primul pas spre a instala Vagrant pe o mașină OS X este a descărca imaginea de instalare _.dmg_ (ultima versiune disponibilă la data creări articolului este **vagrant_v1.7.3.dmg**). Aceasta imagine este disponibilă la [adresa de descărcare a site-ului](http://www.vagrantup.com/downloads.html) Vagrant, ilustrată in imaginea de mai jos:
[<img alt='Imagine pagină de descărcare' src='/assets/images/vagrant/macos/download.png' class="noshadow" />](/assets/images/vagrant/macos/download.png)

După ce imaginea este descărcată, dacă nu se montează automat, faceți `dublu-click` pe fișier pentru a îl monta. După ce imaginea este montată, se va deschide o fereastră _Finder_ cu conținutul, ce va arătă asemănător cu imaginea de mai jos:
[<img alt='Imagine conținut imagine' src='/assets/images/vagrant/macos/image.png' class="noshadow" />](/assets/images/vagrant/macos/image.png)

În acest moment, va trebui executat fișierul `Vagrant.pkg` pentru a iniția instalarea. Instalarea urmează un fir standard de execuție, necesitând apăsarea butonului de continuare de două ori, oferind opțiunea de a schimba locația instalării. La sfârșitul acestui proces, utilizatorul va fi solicitat să introducă parola sa pentru a putea efectua instalarea. Procesul este ilustrat în imaginile de mai jos:

[<img alt='Imagine prim pas al instalării' src='/assets/images/vagrant/macos/firststep.png' class="noshadow" />](/assets/images/vagrant/macos/firststep.png)
[<img alt='Imagine alegere a locației instalării' src='/assets/images/vagrant/macos/installlocation.png' class="noshadow" />](/assets/images/vagrant/macos/installlocation.png)
[<img alt='Imagine solicitare a parolei' src='/assets/images/vagrant/macos/pass.png' class="noshadow" />](/assets/images/vagrant/macos/pass.png)

Instalarea va continua până la sfârșit, prezentând următoarea fereastră:

[<img alt='Imagine terminare instalare' src='/assets/images/vagrant/macos/installcomplete.png' class="noshadow" />](/assets/images/vagrant/macos/installcomplete.png)

În acest moment este recomandată demontarea imaginii, din moment ce instalarea este finalizată. Demontarea se realizează prin apăsarea butonului indicat în imaginea de mai jos.

[<img alt='Imagine demontare imagine' src='/assets/images/vagrant/macos/unmount.png' class="noshadow" />](/assets/images/vagrant/macos/unmount.png)

Din acest moment, utilizarea programului command line `vagrant` va fi posibil folosind aplicația `Terminal.app` (sau `iTerm2.app` sau orice alt emulator terminal preferat). Exemplu de funcționalitate este prezentat mai jos:

[<img alt='Imagine execuție vagrant help' src='/assets/images/vagrant/macos/vagranthelp.png' class="noshadow" />](/assets/images/vagrant/macos/vagranthelp.png)

### Windows

Pentru început, instalați VirtualBox, versiunea pentru Windows! Se poate descărca de  [aici](https://www.virtualbox.org/wiki/Downloads)

După aceasta, instalați Vagrant, versiunea de Windows, ce se găsește [aici](http://www.vagrantup.com/downloads.html). Instalarea este simplă, urmând tiparul obisnuit de _Next_, _Next_, ... _Finish_. După instalare, windows-ul va cere un restart pentru a ajuta Vagrant-ul să-și creeze configurările, iar după restart, puteți verifica în cmd dacă s-a instalat, folosind comanda ```vagrant```. Dacă totul a decurs bine, va trebui să se afișeze ceva asemănător cu ce este în imaginea următoare:

[![Imagine vagrant cmd](/assets/images/vagrant/windows/vagrant_cmd.png)](/assets/images/vagrant/windows/vagrant_cmd.png)

În cele din urmă, a mai rămas un singur pas, și anume faptul că Vagrant are nevoie de un client SSH, iar Windows 7/8 nu îl contine by default, așa că vom folosi Putty. Pentru a-l avea, trebuie doar să-l descărcați de [aici](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) și alegeți ultima versiune pentru Windows (click pe _putty.exe_). Dacă deschideți ceea ce ați descărcat, ar trebui să vă apară o fereastră ce arată cam așa:

[![Imagine putty](/assets/images/vagrant/windows/putty.png)](/assets/images/vagrant/windows/putty.png)


## Quickstart (101)

**Initializare**

Deși atunci când ați rulat `vagrant` în cmd a apărut o listă de comenzi, pentru a seta un server propriu cu ajutorul Vagrant este nevoie doar de câteva dintre ele. Comanda `vagrant init` va crea în director un fișier Vagrantfile, ce conține detalii legate de configurare. Este un exercițiu bun să îl deschideți și să parcurgeți conținutul.

[![Imagine vagrant init](/assets/images/vagrant/windows/vagrant_init.png)](/assets/images/vagrant/windows/vagrant_init.png)

**Cum să vă creați propriul server?**

Pentru început, creați un folder în care va fi proiectul și serverul, apoi deschideți un Command Prompt în acest director, unde rulați comanda:

    $ vagrant init ubuntu/trusty64

Aceasta va crea fișierul Vagrantfile, descris mai sus. Vagrant pune la dispoziția noastră anumite box-uri (detalii în capitolul următor), iar pentru acest exemplu vom folosi `ubuntu/trusty64` care va configura un server cu Ubuntu. Următoarea comandă ce trebuie rulată este:


    $ vagrant up


La prima rulare a acestei comenzi se crează o mașină virtuală conform configurărilor din fișierul Vagrantfile creat la inițializare. Pentru a verifica la final că mașina rulează într-adevăr, deschideți VirtualBox și ar trebui să apară ceva asemănător ca în imagine:

[![Imagine vagrant VirtualBox](/assets/images/vagrant/windows/vagrant_vb.png)](/assets/images/vagrant/windows/vagrant_vb.png)

De asemenea, de fiecare dată când doriți doar să deschideți mașina, se execută comanda `vagrant up`.

Ultima comandă ce trebuie executată este:


    $ vagrant ssh


Aceasta va deschide un shell în Unbuntu, adică în mașina ce tocmai am instalat-o.

**Comenzi utile**

- `vagrant up` , pentru a porni mașina
- `vagrant halt` , pentru a opri mașina
- `vagrant ssh` , pentru a deschide shell-ul mașinii create
- `vagrant reload`, pentru a reporni mașina
- `vagrant destroy`, pentru a șterge mașina și toate configurările acesteia
- `vagrant status` , pentru a verifica statusul mașinii Vagrant (dacă este pornită, oprită, creată, etc)
- `vagrant version`, pentru a afișa versiunea de Vagrant instalată
- `vagrant provision`, pentru a forța rularea tuturor script-urilor (definițiilor) de aprovizionare

Sfat și mic exercițiu: deschideți un Command Prompt și rulați ` vagrant ` pentru a vedea lista tuturor comenzilor disponibile Și o scurtă descriere pentru fiecare, apoi rulați fiecare comandă afișată cu opțiunea ` -h ` (de exemplu, pentru ` init `, rulați ` vagrant init -h ` și așa mai departe cu toate).

### _Box_-uri posibile

După cum ați văzut mai sus, pentru a inițializa o mașină, s-a rulat comanda `vagrant init ubuntu/trusty64`, iar aceasta înseamnă că s-a clonat o mașină virtuală pe care s-a instalt Ubuntu. Vagrant folosește multe astfel de imagini, din care puteam alege ce avea nevoie. Acestea poartă denumirea de _boxes_.

**Cum adăugăm un _box_?**

La adresa [HarshiCorp](https://atlas.hashicorp.com/boxes/search) putem găsi lista întreagă a _box_-urilor disponibile. Pentru a crea o mașină căreia să-i adăugăm apoi un _box_, spre exemplu hashicorp/precise32, folosim următoarele:


    $ vagrant init
    $ vagrant box add hashicorp/precise32


Iar pentru a modifica configurarea și a putea folosi mașina, mai avem un singur pas. Deschideți fișierul Vagrantfile și modifcați următoarele rânduri:


    Vagrant.configure("2") do |config|
        config.vm.box = "hashicorp/precise32"
    end


**Comenzi utile**

- `vagrant box add` + numele _box_-ului, ca în exemplul de mai sus , pentru a adăuga un _box_
- `vagrant box list` , pentru a afișa lista _box_-urilor instalate local
- `vagrant box update` + numele _box_-ului , pentru a actualiza
- `vagrant box remove` + numele _box_-ului , pentru a șterge _box_-ul dorit


Tot ce mai este de făcut mai departe este să porniți mașina cu `vagrant up` și s-o folosiți!

## Configurare Avansată

După cum am menționat mai devreme, `vagrant init` va genera un fișier de configurație numit **Vagrantfile**. Acest fișier este realizat în limbajul **ruby**, și va trebui să respecte *regulile de sintaxă* ale acestui limbaj. Opțiunile de configurare urmează următorul tipar `config.vm.<modul> <opțiuni>` unde *modul* reprezintă modulul resonsabil cu resepectiva configurare (Exemplu: "provision", "network") iar *opțiuni* un set de argumente alocate metodei de configurare. Există excepții de la regulă, respectând tiparul `config.vm.<variabilă> = <valoare>` cu anumite opțiuni simple ce necesită doar atribuirea unei valori.

Exemplu:

    Vagrant.configure("2") do |config|

        # Setarea tipului de *box* folosit
        config.vm.box = "ubuntu/trusty32"

        # Setarea unui canal de provisioning sub forma unui fișier de configurare (explicat mai târziu)
        config.vm.provision :shell, path: "configure"

        # Setarea unui canal de provisioning sub forma unei secvențe de instrucțiuni (explicat mai târziu)
        config.vm.provision :shell, inline: <<-SHELL
            sudo apt-get update
        SHELL

        # Setarea unui alt punct de montare pentru un fișier aparținând sistemului de operare gazdă
        config.vm.synced_folder "../", "/tutorial"

        # Setarea unei configurații de tipul *port forward* (explicat mai târziu)
        config.vm.network "forwarded_port", guest: 8000, host: 9000
    end

Script-urile sunt rulate de către utilizatorul **root** al mașinii virtuale dacă nu este specificat parametrul `privileged: false` al configurației. În acest caz, script-ul este rulat de către utilizatorul **vagrant** al mașinii virtuale. Mașinile virtuale cu sistem de operare Windows nu sunt afectate de acest parametru.

În același timp, script-urile de aprovizionare sunt rulate o singură dată dacă nu este specificat un alt comportament. Prin parametrul `run: 'always'` al configurației, se specifică rularea script-ului la fiecare lansare a mașinii virtuale.

Exemplul de mai jos folosește o metodă de descriere alternativă a configurației, specificând rularea la fiecare lansare și rulează script-ul fără privilegii de administrator.

    config.vm.provision "shell", run: "always" do |setup|
        setup.path = "provision/run_always.sh"
        setup.privileged = false
    end

Mai multe detalii legate de aceste opțiuni pot fi găsite la [această adresă](http://docs.vagrantup.com/v2/provisioning/shell.html).


### Provisioning

Provisioning este modul prin care *Vagrant* pregătește mașina virtuală la fiecare instanțiere. Provisioning-ul se realizează fie printr-un sistem specializat precum **Docker** și **Salt** ([lista completă](http://docs.vagrantup.com/v2/provisioning/index.html)) sau script-uri shell. Pentru scopul acestui tutorial, ne vom limita la a folosi script-uri shell. Acestea pot fi declarate în două moduri diferite, fie printr-un *fișier* (exemplu: `config.vm.provision :shell, path: "configure"`), fie printr-un *string inline* (exemplu: `config.vm.provision :shell, inline: "sudo apt-get update"`). Un exemplu avansat de script de provisioning poate fi găsit în repositorul git al acestui tutorial la [această adresă](https://github.com/sabinmarcu/vagrant-tutorial/tree/master), în folder-ul **advanced** ([link direct](https://github.com/sabinmarcu/vagrant-tutorial/tree/master/advanced)). Acest script este numit **configure**, și, printre funcții auxiliare și de formatare, veți găsi metode ce verifică dacă un anumit software este prezent pe mașina virtuală, și încearcă să îl obțină și să îl instaleze, folosind metode diferite pe sisteme de operare diferite. Acest script a fost testat pe o mașină *Ubuntu* și una *Mac OS X* până la momentul de față. O variantă simplificată a acestui script poate fi găsit în folder-ul în folder-ul **portforward** ([link direct](https://github.com/sabinmarcu/vagrant-tutorial/tree/master/portforward)).

De obicei, când se intenționează folosirea unui singur tip de sistem de operare cu *Vagrant*, configurarea este mult mai simplă.
Exemplu:


    #!/bin/bash

    apt-get update              &> /dev/null || sudo apt-get update             &> /dev/null
    apt-get install python2.7   &> /dev/null || sudo apt-get install python2.7  &> /dev/null
    apt-get install screen      &> /dev/null || sudo apt-get install screen     &> /dev/null


Pentru configurarea provisioning-ului există câteva opțiuni suplimentare ce se pot dovedi utile, printre care:

* `keep_color: true` ce va asigura că Vagrant nu va colora diferit output-ul provisioning-ului (folosirea culorilor în mesajele emise de un provisioning pot fi foarte utile în depanarea script-ului sau mentenanță)

* `run: "always"` ce va asigura că Vagrant va rula acest script la fiecare pornire a mașinii virtuale, nu numai la prima rulare sau când este specificat cu argumentul `--provision` (`vagrant up --provision` / `vagrant provision` / `vagrant reload --provision`)

* `privileged: false` ce va asigura că Vagrant nu va rula acest script sub cont de administrație (root); folosirea argumentului cu valoare adevărată va asigura rularea script-ului cu permisie elevată

Exemplu:


    Vagrant.configure(2) do |config|

        # ...

        config.vm.provision :shell, path: "run", privileged: false, keep_color: true, run: "always"

    end


### Foldere sincronizate

Vagrant are posibilitatea de a sincroniza foldere din mașina gazdă cu cea virtuală. Pentru orice mașină Vagrant există cel puțin o asemenea sincronizare, între folder-ul în care se află fișierul **Vagrantfile** pe *mașina gazdă* și calea `/vagrant` pe mașina virtuală. Asemenea sincronizări adiționale se pot specifica în fișierul **Vagrantfile** ca în exemplul următor:

    Vagrant.configure("2") do |config|

      # ...
      config.vm.synced_folder "~/Desktop", "/host_desktop"

    end


Exemplul de mai sus va sincroniza folderul **Desktop** al utlizatorului curent (se presupune folosirea unui sistem de operare Unix) cu calea `/host_desktop` a mașinii virtuale.

### Port Forwarding

După cum am arătat mai sus, în configurarea unei mașini Vagrant, există opțiunea de a face *port forwarding*. Port forwarding este un mapping între port-uri deschise pe mașina virtuală și pe *host*, sau mașina de pe care este rulată cea virtuală. Această opțiune este foarte utilă în multe cazuri. Spre exemplu, traficul internet pentru port-ul 80 (http standard) al calculatorului de pe care se lucrează mașina Vagrant poate fi redirecționat direct în mașina virtuală, omițând sistemul de operare de bază, pentru a asigura securitatea și izolarea în mașina virtuală. Un alt exemplu ar fi rulând un server simplu de date pe același port în mai multe mașini virtuale identice, dar cu mapping diferit, pentru a fi preluate in *host* de catre un server de colecție, pentru a asigura o formă de paralelism.

Pentru a utiliza *port forwarding*, este necesar a adăuga o linie suplimentară într-o configurație **Vagrantfile**, ca în exemplul următor, unde port-ul **8000** al *mașinii virtuale* este legat de port-ul **9000** al *mașinii gazdă*:



    Vagrant.configure("2") do |config|

      #  ... other configuration options

      # Mapping port 8000 on the virtual machine to port 9000 of the host
      config.vm.network "forwarded_port", guest: 8000, host: 9000

    end



Un exemplu concret este disponibil în repositorul git al acestui tutorial la [această adresă](https://github.com/sabinmarcu/vagrant-tutorial/tree/master), în folder-ul **portforward** ([link direct](https://github.com/sabinmarcu/vagrant-tutorial/tree/master/portforward)). Acest demo conține două script-uri: `configure` care se a asigura că **python** și **screen** există pe mașina virtuală și este rulat doar *o singură dată*, iar `run` va rula un server simplu http cu python în directorul curent (al mașinii gazdă) în mașina virtuală într-o instanță screen pentru a menține execuția indiferent de activitatea utilizatorului, cât timp mașina rulează. Utilizatorul poate verifica starea server-ului și conectivitatea prin accesarea [adresei din mapping](http://localhost:9000). Folder-ul va conține un fișier HTML ce va afișa la ce port rulează aplicația pe server-ul din mașina virtuală, și la ce port este accesat de utilizator.


<style>
.page-content .post .post-content img{
    display: block;
    width: 100%;
	margin: 20px auto;
}
.page-content .post .post-content img:not(.noshadow){
    box-shadow: 0 5px 8px 0 rgba(0, 0, 0, 0.2);
    -webkit-box-shadow: 0 5px 8px 0 rgba(0, 0, 0, 0.2);
    -moz-box-shadow: 0 5px 8px 0 rgba(0, 0, 0, 0.2);
    -ms-box-shadow: 0 5px 8px 0 rgba(0, 0, 0, 0.2);
    -o-box-shadow: 0 5px 8px 0 rgba(0, 0, 0, 0.2);
}
</style>
