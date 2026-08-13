---
layout: post
title:  "Hackathon Intern 1"
date:   2015-04-07 23:16:02
author: "Alex Palcuie"
categories: stiri
---

Weekendul acesta o echipă de voluntari InfoEducație s-a strâns la București și a lucrat la migrarea forumului vechi, dezvoltarea website-ului nou și repararea câtorva buguri pe website-ul vechi.

<!-- more -->

Numele meu este Alex Palcuie și sunt student la Facultatea de Matematică și Informatică și fost inginer la Hootsuite. Robert Dolca e student la Facultatea de Automatică și Calculatoare și inginer la Intel. Vlad Temian a venit tocmai de la Timișoara, unde e student la Facultatea de Matematică și Informatică și inginer la Presslabs. Din San Francisco, Bogdan Gâza, inginer la Twitter a supravegheat că nu stăm doar de povești și ne concentrăm pe lucrurile care trebuie care contează cu adevărat. Toți am fost în juriul InfoEducație la secțiunea web.

Vlad a venit cu prietena lui, Doinița Spuză, care ne-a bătut la cap să mai dorm din când în când și ne-a gătit extraordinar.

{: .center}
![poză cu spaghetele](/assets/images/hackathon-intern-1/spaghete.png)

Bogdan lucrase dinainte la [API-ul](https://github.com/infoeducatie/infoeducatie-api) nou scris în Rails. Sarcini rezolvate:

- am stabilit toate modelele și atributele lor
- am integrat Devise pentru managementul userilor
- am integrat RailsAdmin ca să putem administra datele din aplicație mai ușor
- am curățat view-urile ca să servim doar formatul JSON
- scriem teste de unit ca să păstrăm codul ușor de întreținut, avem testele rulate automat pe TravisCI și când apeși butonul de lansare API-ul se updatează automat pe Heroku

Pentru interfața web, ne-am hotărât să scriem o aplicație de Javascript care va consuma API-ul. Băieții au avut încredere în mine să aleg tehnologiile, iar apoi am primit titulatura de _Chief Hipster Officer_ pentru că ele sunt destul de noi.

<div class="center"><div id="fb-root"></div><script>(function(d, s, id) {  var js, fjs = d.getElementsByTagName(s)[0];  if (d.getElementById(id)) return;  js = d.createElement(s); js.id = id;  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.3";  fjs.parentNode.insertBefore(js, fjs);}(document, 'script', 'facebook-jssdk'));</script><div class="fb-post" data-href="https://www.facebook.com/photo.php?fbid=10203354237251257&amp;set=a.1629379388961.71500.1670899814&amp;type=1" data-width="500"><div class="fb-xfbml-parse-ignore"><blockquote cite="https://www.facebook.com/photo.php?fbid=10203354237251257&amp;set=a.1629379388961.71500.1670899814&amp;type=1"><p>#ES6 #Javascript #React #Webpack #Rails pentru Infoeducatie</p>Posted by <a href="https://www.facebook.com/palcuiealex">Alex Palcuie</a> on <a href="https://www.facebook.com/photo.php?fbid=10203354237251257&amp;set=a.1629379388961.71500.1670899814&amp;type=1">Friday, April 3, 2015</a></blockquote></div></div></div>

Ce am făcut:

- am decis să folosim React, o bibliotecă super faină de la Facebook
- le-am ținut băieților un tutorial ca să mai scădem din [bus factorul](http://en.wikipedia.org/wiki/Bus_factor) pe partea de frontend
- scriem [cod ES6](https://github.com/infoeducatie/infoeducatie-ui/blob/572ad9cb41b2ec69e558c95aeb47c7d741752ae6/src/main.jsx), cea mai modernă versiune a limbajului Javascript
- am experimentat cu câteva biblioteci pentru formulare și Bootstrap
- momentan funcționează doar autentificarea, dar având o bază solidă putem mai ușor să dezvoltăm de la distanță

Am migrat și toate proiectele de pe forumul vechi pe [cel nou](http://community.infoeducatie.ro/) și toți utilizatorii. În curând vom termina de migrat și toate discuțiile interesante de acolo, pentru a nu se pierde din istorie.

Au fost reparate link-urile de la proiectele din [anii trecuți](http://infoeducatie.ro/participanti.php?year=2014) și am actualizat rezultatele din anii trecuți să fie în același [format](http://infoeducatie.ro/rezultate.php).

În final, am comandat o pizza delicioasă și am recuperat câteva ore de somn. Dacă vrei să discuți cu noi și să contribui, poți intra pe canalul nostru de [Slack](https://infoeducatie.slack.com/).

{: .center}
![pizza](/assets/images/hackathon-intern-1/pizza.png)
