# MelbourneWeather
A weather app only for Melbourne. #PracticeStructure #MVVM-like-structure #decoupleable #expandable

This app is a practice project from MVVM-like-structure. 
There are four folders in my Xcode projects: View, Manager, Modal, ViewModel. 
They pass messages(datas) in one directiona. The way of passing message is not only in KVO as in MVVM strucutre,
but also delegae, callback or message sending( like old MVC style). The reason I didn't use completely MVVM structure is because ReactiveCocoa is not usable at this moment.
The project is quite expandable becuase those classes are decoupled and are SOLID.

Here is the API source: http://openweathermap.org/

Please enjoy watching how I design those classes.
