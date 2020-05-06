import 'state_model.dart';

class Repository {
  List<Map> getAll() => _nigeria;

  getLocalByState(String state) => _nigeria
      .map((map) => StateModel.fromJson(map))
      .where((item) => item.state == state)
      .map((item) => item.lgas)
      .expand((i) => i)
      .toList();
  List<String> getStates() => _nigeria
      .map((map) => StateModel.fromJson(map))
      .map((item) => item.state)
      .toList();

  List _nigeria = [
    {
      "state": "United States",//country_id 223
      "alias": "United States",
      "lgas": [
        "Alabama",
        "Alaska",
        "American Samoa",
        "Arizona",
        "Arkansas",
        "Armed Forces Africa",
        "Armed Forces Americas",
        "Armed Forces Canada",
        "Armed Forces Europe",
        "Armed Forces Middle East",
        "Armed Forces Pacific",
        "California",
        "Colorado",
        "Connecticut",
        "Delaware",
        "District of Columbia",
        "Federated States Of Micronesia",
        "Florida",
        "Georgia",
        "Guam",
        "Hawaii", 
        "Idaho",
        "Illinois",
        "Indiana",
        "Iowa",
        "Kansas",
        "Kentucky",
        "Louisiana",
        "Maine",
        "Marshall Islands",
        "Maryland",
        "Massachusetts",
        "Michigan", 
        "Minnesota",
        "Mississippi",
        "Missouri",
        "Montana",
        "Nebraska",
        "Nevada",
        "Hampshire",
        "New Jersey",
        "New Mexico",
        "New York",
        "North Carolina", 
        "North Dakota",
        "Northern Mariana Islands",
        "Ohio",
        "Oklahoma",
        "Oregon",
        "Palau",
        "Pennsylvania",
        "Puerto Rico",
        "Rhode Island",
        "South Carolina",
        "South Dakota",
        "Tennessee",
        "Texas",
        "Utah",
        "Vermont",
        "Virgin Islands",
        "Virginia",
        "Washington",
        "West Virginia",
        "Wisconsin",
        "Wyoming"
      ]
    },
  ];
}
