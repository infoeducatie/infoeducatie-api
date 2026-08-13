---
layout: post
title:  "Tutorial VirtualBox"
date:   2015-07-25 20:--:00
author: "Sabin Marcu & Elena Pistol"
categories: tutorial
---


Virtual Box este o aplicație care își propune să vină în ajutorul nostru atunci când avem nevoie rapid și ușor de o mașină care să îndeplinească anumite specificații, atât hardware, cât și software. Astfel, urmând câțiva pași simpli, putem crea mașini virtule cu orice sistem de operare, diferit de cel pe care-l avem pe mașina locală. În plus, după ce am creat mașini virtuale proprii, cu specificațiile dorite, putem să le facem copii, sau să le clonăm și folosi pe orice alt computer.

De asemenea, Virtual Box nu este dependent de sistemul de operare, astfel că poate fi instalat și folosit pe orice platformă.

**De ce să folosim Virtual Box?**

În primul rând, cu Virtual Box putem avea mașini cu diferite configurații și sisteme de operare, ce pot fi pornite simultan. Acest lucru ne ajută foarte mult atunci când avem de testat comportamente ale aplicațiilor pe diferite platforme. Pe lângă aceasta, Virtual Box ne permite să salvăm stări ale mașinilor (Snapshot), ca mai apoi să revenim la ele, fără să se fi alterat dacă am făcut o modificare greșita între timp.

## Instalare

### Mac OS X

Pentru a instala Virtual Box, accesați [pagina de download](https://www.virtualbox.org/wiki/Downloads) și descărcați versiunea pentru Mac OS X, _VirtualBox 5.0 for OS X hosts_. Imaginea descărcată, după ce va fi descărcată și deschisă, va arăta ca în imaginea de mai jos:

[<img alt="Descriere imagine" class="noshadow" src="/assets/images/virtualbox/macos/dmgcontent.png" />](/assets/images/virtualbox/macos/dmgcontent.png)

Utilitarul de instalare se numește `VirtualBox.pkg`. Accesați utilitarul pentru a continua instalarea. Pașii de instalare sunt descriși în continuare:

[<img alt="Verificare cerințe" class="noshadow" src="/assets/images/virtualbox/macos/oscheck.png" />](/assets/images/virtualbox/macos/oscheck.png)
[<img alt="Meniu opțiuni" class="noshadow" src="/assets/images/virtualbox/macos/optsmenu.png" />](/assets/images/virtualbox/macos/optsmenu.png)

În acest punct, două opțiuni de configurare sunt disponibile: **Customize** și **Change install location**. Prin apăsarea butonului *Customize* putem modifica ce componente vor fi instalate, precum ilustrează imaginea de mai jos:

[<img alt="Customizare componente" class="noshadow" src="/assets/images/virtualbox/macos/custominstall.png" />](/assets/images/virtualbox/macos/custominstall.png)

Prin apăsarea butonului *Change install location* putem modifica locația unde va fi instalat *VirtualBox*, precum ilustrează imaginea de mai jos:

[<img alt="Customizare cale instalare" class="noshadow" src="/assets/images/virtualbox/macos/location.png" />](/assets/images/virtualbox/macos/location.png)

După apăsarea butonului **Install**, utilizatorul va fi solicitat să își introducă parola pentru a putea continua instalarea:

[<img alt="Solicitare parolă" class="noshadow" src="/assets/images/virtualbox/macos/password.png" />](/assets/images/virtualbox/macos/password.png)

Din acest moment, instalarea va progresa fără a necesita orice interacțiune suplimetară din partea utilizatorului, proces ilustrat în imaginile următoare:

[<img alt="Progres instalare" class="noshadow" src="/assets/images/virtualbox/macos/installprogress.png" />](/assets/images/virtualbox/macos/installprogress.png)
[<img alt="Instalare completată" class="noshadow" src="/assets/images/virtualbox/macos/installsuccess.png" />](/assets/images/virtualbox/macos/installsuccess.png)

### Windows

Pentru a instala Virtual Box, accesați [pagina de download](https://www.virtualbox.org/wiki/Downloads) și descărcați versiunea pentru Windows, _VirtualBox 5.0 for Windows hosts_. Pașii de instalare sunt descriși în imaginile ce urmează:

[![Instare virtual box pas 1](/assets/images/virtualbox/windows/install-step1.png)](/assets/images/virtualbox/windows/install-step1.png)

În următorul pas utilizatorul poate alege ce componente ale aplicației să fie instalate și locația unde aceasta va fi instalată. De cele mai multe ori, opțiunile predefinite sunt suficiente.

[![Instare virtual box pas 2](/assets/images/virtualbox/windows/install-step2.png)](/assets/images/virtualbox/windows/install-step2.png)

În acest moment, utilizatorul poate alege dacă dorește să se creeze scurtături desktop, etc sau dacă dorește ca anumite tipuri de fișiere să fie asociate cu *VirtualBox*.

[![Instare virtual box pas 3](/assets/images/virtualbox/windows/install-step3.png)](/assets/images/virtualbox/windows/install-step3.png)

[![Instare virtual box pas 4](/assets/images/virtualbox/windows/install-step4.png)](/assets/images/virtualbox/windows/install-step4.png)

[![Instare virtual box pas 5](/assets/images/virtualbox/windows/install-step5.png)](/assets/images/virtualbox/windows/install-step5.png)

[![Instare virtual box pas 6](/assets/images/virtualbox/windows/install-step6.png)](/assets/images/virtualbox/windows/install-step6.png)

Este necesar instalarea unor drivere suplimentare pentru funcționarea și integrarea completă a aplicației cu sistemul de operare. La mesaje asemănătoare cu cel de mai jos, apăsați butonul *Install* pentru a permite instalarea acestora.

[![Instare virtual box pas 7](/assets/images/virtualbox/windows/install-step7.png)](/assets/images/virtualbox/windows/install-step7.png)

În acest moment, instalarea este terminată, iar utilizatorul poate începe să folosească *VirtualBox*.

[![Instare virtual box pas 8](/assets/images/virtualbox/windows/install-step8.png)](/assets/images/virtualbox/windows/install-step8.png)

## Quickstart (101)

În următoarele capitole vom descrie crearea unei mașini virtuale noi, și instalarea unui sistem de operare pe aceasta.

### Creare Mașină Virtuală

La deschiderea aplicației **VirtualBox**, utilizatorul va fi întâmpinat de următoarea interfață:

[<img alt="Start Virtualbox" class="noshadow" src="/assets/images/virtualbox/quickstart/start.png" />](/assets/images/virtualbox/quickstart/start.png)

De aici, pentru a crea o nouă mașină virtuală, utilizatorul va trebui să apese pe butonul **New**. În continuare, procesul de creare va porni cu urmatoarea solicitare de informații:

[<img alt="Numele și tipul Mașinii Virtuale" class="noshadow" src="/assets/images/virtualbox/quickstart/nameandtype.png" />](/assets/images/virtualbox/quickstart/nameandtype.png)

Utilizatorul va trebui să ofere un nume mașinii virtuale, să definească tipul sitemului de operare ce va fi folosit, urmând ca la sfărșit să specifice cantitatea de RAM alocată mașinii virtuale cât timp aceasta rulează.

[<img alt="Cantitatea de RAM" class="noshadow" src="/assets/images/virtualbox/quickstart/ram.png" />](/assets/images/virtualbox/quickstart/ram.png)

Din acest moment, mai rămâne de configurat doar spațiul de stocare al datelor (HDD). Procesul standard este să se creeze un disc virtual nou, de tip *VDI* (VirtualBox), cu alocare dinamică a spațiului. Mărimea disc-ului depinde de sistemul de operare dorit. Procesul este ilustrat în următoarele imagini:

[<img alt="Solicitare HDD" class="noshadow" src="/assets/images/virtualbox/quickstart/virtualhdd.png" />](/assets/images/virtualbox/quickstart/virtualhdd.png)
[<img alt="Tip HDD" class="noshadow" src="/assets/images/virtualbox/quickstart/hddtype2.png" />](/assets/images/virtualbox/quickstart/hddtype2.png)
[<img alt="Format HDD" class="noshadow" src="/assets/images/virtualbox/quickstart/hddtype.png" />](/assets/images/virtualbox/quickstart/hddtype.png)
[<img alt="Marime HDD" class="noshadow" src="/assets/images/virtualbox/quickstart/hddsize.png" />](/assets/images/virtualbox/quickstart/hddsize.png)

### Instalare Sistem de Operare

În acest moment, mașina virtuală este creată și configurată. Ea va figura în meniul de început, și va arăta informații similare cu cele din imaginea de mai jos:

[<img alt="Mașină virtuală creată" class="noshadow" src="/assets/images/virtualbox/quickstart/startupdate.png" />](/assets/images/virtualbox/quickstart/startupdate.png)

Pentru a instala ceva pe această mașină virtuală totuși, este necesar să o pornim folosind butonul **Start**.

[<img alt="Bootare mașină virtuală" class="noshadow" src="/assets/images/virtualbox/quickstart/vbboot.png" />](/assets/images/virtualbox/quickstart/vbboot.png)

Va trebui să configurăm o imagine montată în locul unității optice virtuale. Vom face acest lucru prin a da click dreapta pe icoana asemănătoare unui disc optic în bara de status (aflată în partea de jos a ferestrei) și selectarea unei imagini, proces ilustrat în imaginile de mai jos:

[<img alt="Bootare mașină virtuală" class="noshadow" src="/assets/images/virtualbox/quickstart/vbbootedit.png" />](/assets/images/virtualbox/quickstart/vbbootedit.png)
[<img alt="Alegere imagine" class="noshadow" src="/assets/images/virtualbox/quickstart/choosedisk.png" />](/assets/images/virtualbox/quickstart/choosedisk.png)

Din acest moment, se procedează prin instalarea sistemului de operare dorit. Pentru exemplu, continuând exemplul de mai sus, am instalat Ubuntu Server pe o mașină virtuală:

[<img alt="Bootare Ubuntu" class="noshadow" src="/assets/images/virtualbox/quickstart/ubuntuboot.png" />](/assets/images/virtualbox/quickstart/ubuntuboot.png)
[<img alt="Detalii Ubuntu" class="noshadow" src="/assets/images/virtualbox/quickstart/ubuntuinstalled.png" />](/assets/images/virtualbox/quickstart/ubuntuinstalled.png)

## Configurare avansată

Fiecare mașină virtuală creată în VirtualBox are o configurare proprie, pe care o putem accesa oricând dorim. În această secțiune vom parcurge fiecare tab din _Settings_ (se găsește imediat deasupra) și vom vedea la ce ajută fiecare opțiune. În primă fază, atunci când deschidem fereastra, vom vedea mai multe tab-uri:

[![Configurare avansată, general](/assets/images/virtualbox/configurare_avansata/general.png)](/assets/images/virtualbox/configurare_avansata/general.png)

### General

În acest tab sunt incluse configurările fundamentale. Acesta este împărțit în 3 sub-tab-uri, din care în _Basic_ putem configura numele mașinii virtuale. Sistemul de operare și versiunea acestuia, chiar dacă pot fi schimbate aparent, setările vor rămâne aceleași ca atunci când s-a cret mașina.

In tabul _Advanced_, putem adăuga calea către Snapshot-ul în care este creată mașina noastră virtuală, în secțiunea _Snapshot Folder_. În _Shared Clipboard_,  putem seta modul în care putem accesa clipboad-ul atât local, cât și în mașina virtuală. Astfel, pentru _Disabled_, clipboard-ul de pe host-ul local nu va putea fi folosit, iar pentru _Bidirectional_ va putea fi folosit. Setările _Host to Guest_ și _Guest to Host_ permite partajarea clipboard-ului doar unidirecțional. Același lucru este și pentru _Drag'n'Drop_, doar că aici se face referire la partajarea fișierelor între host-ul local și mașina virtuală. Ultimele două checkbox-uri sunt setări cu privire la modul de vizualizare al mini toolbar-ului, si dacă dorim ca fișierele media să fie salvate sau nu.

În tab-ul _Description_ pot fi adăugate orice informații sau detalii legate de mașina virtuală.

### System

[![Configurare avansată, system](/assets/images/virtualbox/configurare_avansata/system.png)](/assets/images/virtualbox/configurare_avansata/system.png)

În _System_, se pot adăga setări pentru pentru partea hardware a mașinii virtuale. În primul sub-tab, _Motherboard_, se poate seta RAM-ul alocat mașinii, însă trebuie să avem grijă ca pe host să avem această memorie disponibilă. De asemenea, se poate seta ordinea în care vrem să se boot-eze vașina virtuală. Aceasta va funcționa la fel ca o mașină reală.

În al doilea sub-tab, _Processor_, se poate adăuga numărul de procesoare (CPU), însă trebuie să avem grijă ca aceste procesoare să fie într-adevăr disponibile. Pentru a verifica asta, Virtual Box are o zonă marcată cu roșu, în care nu trebuie să intrăm. _CPU execution cap_ setează limita de timp pe care host-ul îl petrece pentru a emula CPU-ul virtual. O limitare mai mică 50% poate induce probleme mașinii virtuale.

### Display

[![Configurare avansată, display](/assets/images/virtualbox/configurare_avansata/display.png)](/assets/images/virtualbox/configurare_avansata/display.png)

În _Display_ putem seta memoria video pe care vrem să o alocăm mașinii virtuale. Ca și în cazul setărilor de sistem, aici există o limită pe care o putem configura (zona marcată cu roșu nu este ok) depinzând de configurația de care dispunem pe mașina reală. De asemenea, putem alege numărul de monitoare pe care mașina virtuală le poate accesa atunci când dispunem de mai multe monitoare.

### Storage

[![Configurare avansată, storage](/assets/images/virtualbox/configurare_avansata/storage.png)](/assets/images/virtualbox/configurare_avansata/storage.png)

 VirtualBox ne permite în _Storage_ să setăm _virtual storage controllers_ pentru mașina virtuală, dându-ne astfel libertatea de a obține o mașină după placul nostru. Pentru început, în aceast tab se poate găsi un controller SATA (adică mașina are un hard disk virtual atașat), iar dacă mașina a fost creată folosind un ISO, atunci aici se va găsi încă un controller IDE (adică mașina are atașat un CD/DVD virtual).

Jos se pot vedea iconițe care permit adăugarea mai multor controllere. Astfel, cu ajutorul primului buton putem adăuga un CD/DVD sau un hard disk nou pentru controller-ul selectat, iar al treilea buton permite adăugarea unui nou tip de controller. Al doilea și al patrulea sunt pentru ștergere.

### Audio

[![Configurare avansată, audio](/assets/images/virtualbox/configurare_avansata/audio.png)](/assets/images/virtualbox/configurare_avansata/audio.png)

Aici se poate activa sau dezactiva controller-ul audio pentru mașina virtuală.

### Network

[![Configurare avansată, ntework](/assets/images/virtualbox/configurare_avansata/network.png)](/assets/images/virtualbox/configurare_avansata/network.png)

VirtualBox permite activarea a până la 4 adaptere pentru placa de rețea, iar în tab-ul _Network_ putem seta date precum tipul, adresa MAC, reguli pentru Port Forwarding.

În primă instanță, avem opțiunea de a selecta modul de _networking_. Aici putem alege între mai multe opțiuni:

- Not attached: mașina virtuală nu va avea nicio conexiune la Internet
- NAT (Network Address Translation): acesta este modul default setat de VirtualBox la crearea unei mașini noi și permite accesarea Internetului de către mașina virtuală
- Bridged networking: se folosește atunci când dorim să simulăm conexiunea la o rețea sau să rulăm servere în mașina virtuală.

### Serial Ports

[![Configurare avansată, serial ports](/assets/images/virtualbox/configurare_avansata/serial_ports.png)](/assets/images/virtualbox/configurare_avansata/serial_ports.png)

### USB

[![Configurare avansată, USB](/assets/images/virtualbox/configurare_avansata/usb.png)](/assets/images/virtualbox/configurare_avansata/usb.png)

Această setare, dacă este activată, permite mașinii virtuale să acceseze conținutul device-urilor USB de pe mașina reală.

### Shared Folders

[![Configurare avansată, shared folders](/assets/images/virtualbox/configurare_avansata/shared_folders.png)](/assets/images/virtualbox/configurare_avansata/shared_folders.png)

Aici se pot vedea lista fișierelor de pe mașina reală la care mașina virtuală are acces, precum și tipul de acces (Full sau Read-Only). Tot de aici putem modifica, șterge sau adăuga alte fișiere pe care să le partajăm cu mașina virtuală, folosind butoanele din dreapta.

## Import / Export

### Export

Pe lângă faptul că în Virtual Box se pot crea mașini virtuale proprii, acestea pot fi și exportate, creându-se asftel copii ale unei mașini existente, ce pot fi apoi importate în alte locații. Prin exportare, sunt păstrate toate setările mașinii create, inclusiv sistemul de operare și configurările pentru RAM și CPU.

Primul pas este să deschideți Oracle VM VirtualBox Manager, iar apoi accesați din meniul principal _File_ > _Export Appliance..._. Va fi deschisă o nouă fereastră, în care trebuie să selectăm mașina ce dorim s-o exportăm, și apăsăm _Export Mode_ (în versiunile mai vechi de VirtualBox, butonul _Export Mode_ este înlocuit cu numele _Hide Description_).

[![Import pas 1](/assets/images/virtualbox/export/export-step1.png)](/assets/images/virtualbox/export/export-step1.png)

După ce selectăm _Export Mode_, vom vedea o fereastră ce conține detaliile mașinii virtuale. Aici trebuie să alegem locația în care dorim să ne salvăm mașina după ce va fi exportată. Aceasta va fi salvată în format .ovf sau .ova (Open Virtualization Format). Având toate acestea, putem apăsa _Export_ și așteptăm câteva minute până se copiază fișierul.

[![Import pas 2](/assets/images/virtualbox/export/export-export_mode.png)](/assets/images/virtualbox/export/export-export_mode.png)

La final, pentru a verifica faptul că s-a exportat totul cu succes, putem merge în locația în care ne-am dorit să fie exportată mașina. Aici vom găsi un fișier nou, care va putea fi apoi importat și folosit.

[![Import pas 3](/assets/images/virtualbox/export/export-show-file.png)](/assets/images/virtualbox/export/export-show_file.png)

### Import

Mașinile virtuale exportate, pot fi și importate în Virtual Box. Astfel, având un fișier în format .ovf sau .ova (Open Virtualization Format), și urmând pașii descriși în continuare, puteți avea o copie a altei mașini virtuale, ce fusese exportată.

În primul rând, deschideți Oracle VM VirtualBox Manager, iar pentru a importa, accesați din meniu _File_, apoi _Import Appliance..._. Aceasta va deschide o fereastră care va cere un fișier. Tot ce este nevoie la acest pas, este să introduceți calea către fișierul ce conține datele pentru mașina ce doriți s-o importați, apoi apasați _Next_.

[![Import pas 1](/assets/images/virtualbox/import/import-step1.png)](/assets/images/virtualbox/import/import-step1.png)

În fereastra următoare sunt afișate configurările setate pentru mașina virtuală. Aici puteți vedea detalii, precum numele mașinii, sistemul de operare pe care îl folosește, CPU-ul, RAM-ul. Singurele setări pe care le putem schimba noi sunt cele legate de Network, sunet, USB, DVD.

[![Import pas 2](/assets/images/virtualbox/import/import-step2.png)](/assets/images/virtualbox/import/import-step2.png)

[![Import pas 3](/assets/images/virtualbox/import/import-step3.png)](/assets/images/virtualbox/import/import-step3.png)

După ce apăsați _Import_, va dura câteva minute până se va finaliza procesul, iar apoi veți putea vedea în fereastra de VirtualBox o nouă mașină, având configurația mașinii importate. Tot ce mai rămâne este să fie pornită și folosită. De asemenea, setările noii mașini virtuale se pot accesa / modifica oricând, accesând _Settings_ din meniu.

[![Import pas 4](/assets/images/virtualbox/import/import-step4.png)](/assets/images/virtualbox/import/import-step4.png)


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
