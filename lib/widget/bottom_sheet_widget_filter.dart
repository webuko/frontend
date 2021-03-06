import 'package:airbnb/api/flat_provider.dart';
import 'package:airbnb/api/neigbourhood_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class BottomSheetWidgetFiltering extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomSheetWidgetFilteringState();
}

class FilterSettings {
  //Numeric filters
  RangeValues _currentRangeValuesPrice = const RangeValues(0, 200);
  RangeValues _currentRangeValuesBedrooms = const RangeValues(1, 10);
  RangeValues _currentRangeValuesBathrooms = const RangeValues(1, 10);
  RangeValues _currentRangeValuesAccommodates = const RangeValues(1, 20);
  bool _priceChecked = false;
  bool _bedroomsChecked = false;
  bool _bathroomsChecked = false;
  bool _accommodatesChecked = false;

  bool get priceChecked {
    return _priceChecked;
  }

  bool get bedroomsChecked {
    return _bedroomsChecked;
  }

  bool get bathroomsChecked {
    return _bathroomsChecked;
  }

  bool get accommodatesChecked {
    return _accommodatesChecked;
  }

  RangeValues get currentRangeValuesPrice {
    return _currentRangeValuesPrice;
  }

  RangeValues get currentRangeValuesBedrooms {
    return _currentRangeValuesBedrooms;
  }

  RangeValues get currentRangeValuesBathrooms {
    return _currentRangeValuesBathrooms;
  }

  RangeValues get currentRangeValuesAccommodates {
    return _currentRangeValuesAccommodates;
  }

  //Filters by String
  String? propertyType = "";
  String? roomType = "";
  String? neighbourhood = "";

  bool _propertyTypeChecked = false;
  bool _roomTypeChecked = false;
  bool _neighbourhoodChecked = false;

  bool get propertyTypeChecked {
    return _propertyTypeChecked;
  }

  bool get roomTypeChecked {
    return _roomTypeChecked;
  }

  bool get neighbourhoodTypeChecked {
    return _neighbourhoodChecked;
  }

  String get currentPropertyType {
    return propertyType!;
  }

  String get currentRoomType {
    return roomType!;
  }

  String get currentNeighbourhood {
    return neighbourhood!;
  }
}

class _BottomSheetWidgetFilteringState
    extends State<BottomSheetWidgetFiltering> {
  final String title = "BottomSheetWidget";
  FilterSettings filterSettings = FilterSettings();

  final controllerPropertyType = TextEditingController();
  final controllerRoomType = TextEditingController();
  final controllerNeighbourhood = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final myFlatProvider = context.watch<FlatProvider>();
    final myNeighbourhoodProvider = context.watch<NeighbourhoodProvider>();

    List<String> getSuggestionsPropertyTypes(String query) =>
        List.of(myFlatProvider.allPropertyType).where((input) {
          final inputLower = input.toLowerCase();
          final queryLower = query.toLowerCase();
          return inputLower.contains(queryLower);
        }).toList();

    List<String> getSuggestionsRoomTypes(String query) =>
        List.of(myFlatProvider.allRoomTypes).where((input) {
          final inputLower = input.toLowerCase();
          final queryLower = query.toLowerCase();
          return inputLower.contains(queryLower);
        }).toList();

    List<String> getSuggestionsNeighbourhood(String query) =>
        List.of(myFlatProvider.allNeighbourhood).where((input) {
          final inputLower = input.toLowerCase();
          final queryLower = query.toLowerCase();
          return inputLower.contains(queryLower);
        }).toList();

    Widget buildPropertyType() => TypeAheadFormField<String?>(
          direction: AxisDirection.up,
          textFieldConfiguration: TextFieldConfiguration(
            controller: controllerPropertyType,
          ),
          suggestionsCallback: getSuggestionsPropertyTypes,
          itemBuilder: (context, String? suggestion) => ListTile(
            title: Text(suggestion!),
          ),
          onSuggestionSelected: (String? suggestion) => {
            controllerPropertyType.text = suggestion!,
          },
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please select a property type!';
            } else if (!myFlatProvider.allPropertyType.contains(value)) {
              return 'Please select a existing property type!';
            } else {
              return null;
            }
          },
          onSaved: (value) => filterSettings.propertyType = value,
        );

    Widget buildRoomType() => TypeAheadFormField<String?>(
          direction: AxisDirection.up,
          textFieldConfiguration: TextFieldConfiguration(
            controller: controllerRoomType,
          ),
          suggestionsCallback: getSuggestionsRoomTypes,
          itemBuilder: (context, String? suggestion) => ListTile(
            title: Text(suggestion!),
          ),
          onSuggestionSelected: (String? suggestion) => {
            controllerRoomType.text = suggestion!,
          },
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please select a room type!';
            } else if (!myFlatProvider.allRoomTypes.contains(value)) {
              return 'Please select a existing room type!';
            } else {
              return null;
            }
          },
          onSaved: (value) => filterSettings.roomType = value,
        );

    Widget buildNeighbourhoodType() => TypeAheadFormField<String?>(
          direction: AxisDirection.up,
          textFieldConfiguration: TextFieldConfiguration(
            controller: controllerNeighbourhood,
          ),
          suggestionsCallback: getSuggestionsNeighbourhood,
          itemBuilder: (context, String? suggestion) => ListTile(
            title: Text(suggestion!),
          ),
          onSuggestionSelected: (String? suggestion) => {
            controllerNeighbourhood.text = suggestion!,
          },
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please select a neighbourhood!';
            } else if (!myFlatProvider.allNeighbourhood.contains(value)) {
              return 'Please select a existing neighbourhood!';
            } else {
              return null;
            }
          },
          onSaved: (value) => filterSettings.neighbourhood = value,
        );

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          if (_isLoading == true)
            const SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                "Filter Listings (${myFlatProvider.allFlats.length} flats left)",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          Container(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: this.filterSettings._priceChecked,
                  onChanged: (value) {
                    setState(() {
                      this.filterSettings._priceChecked = value!;
                    });
                  },
                ),
                Container(
                  width: 100,
                  child: const Text("Price"),
                ),
                if (filterSettings._priceChecked == false)
                  Container()
                else
                  Container(
                    width: 80,
                    child: Text(
                      "(\$${filterSettings._currentRangeValuesPrice.start.round()} - \$${filterSettings._currentRangeValuesPrice.end.round()})",
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (filterSettings._priceChecked == false)
                  Container()
                else
                  Expanded(
                    child: RangeSlider(
                      values: filterSettings._currentRangeValuesPrice,
                      min: 0,
                      max: 1000,
                      divisions: 1000,
                      labels: RangeLabels(
                        filterSettings._currentRangeValuesPrice.start
                            .round()
                            .toString(),
                        filterSettings._currentRangeValuesPrice.end
                            .round()
                            .toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          filterSettings._currentRangeValuesPrice = values;
                        });
                        //  _submit(filterSettings, myFlatProvider);
                      },
                    ),
                  )
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: this.filterSettings._bedroomsChecked,
                  onChanged: (value) {
                    setState(() {
                      this.filterSettings._bedroomsChecked = value!;
                    });
                  },
                ),
                Container(
                  width: 100,
                  child: Text("Bedrooms"),
                ),
                if (filterSettings._bedroomsChecked == false)
                  Container()
                else
                  Container(
                    width: 80,
                    child: Text(
                      "(${filterSettings._currentRangeValuesBedrooms.start.round()} - ${filterSettings._currentRangeValuesBedrooms.end.round()})",
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (filterSettings._bedroomsChecked == false)
                  Container()
                else
                  Expanded(
                    child: RangeSlider(
                      values: filterSettings._currentRangeValuesBedrooms,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      labels: RangeLabels(
                        filterSettings._currentRangeValuesBedrooms.start
                            .round()
                            .toString(),
                        filterSettings._currentRangeValuesBedrooms.end
                            .round()
                            .toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          filterSettings._currentRangeValuesBedrooms = values;
                        });
                      },
                    ),
                  )
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: this.filterSettings._bathroomsChecked,
                  onChanged: (value) {
                    setState(() {
                      this.filterSettings._bathroomsChecked = value!;
                    });
                  },
                ),
                Container(
                  width: 100,
                  child: const Text("Bathrooms"),
                ),
                if (filterSettings._bathroomsChecked == false)
                  Container()
                else
                  Container(
                    width: 80,
                    child: Text(
                      "(${filterSettings._currentRangeValuesBathrooms.start.round()} - ${filterSettings._currentRangeValuesBathrooms.end.round()})",
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (filterSettings._bathroomsChecked == false)
                  Container()
                else
                  Expanded(
                    child: RangeSlider(
                      values: filterSettings._currentRangeValuesBathrooms,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      labels: RangeLabels(
                        filterSettings._currentRangeValuesBathrooms.start
                            .round()
                            .toString(),
                        filterSettings._currentRangeValuesBathrooms.end
                            .round()
                            .toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          filterSettings._currentRangeValuesBathrooms = values;
                        });
                      },
                    ),
                  )
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: this.filterSettings._accommodatesChecked,
                  onChanged: (value) {
                    setState(() {
                      this.filterSettings._accommodatesChecked = value!;
                    });
                  },
                ),
                Container(
                  width: 100,
                  child: const Text("Accommodates"),
                ),
                if (filterSettings._accommodatesChecked == false)
                  Container()
                else
                  Container(
                    width: 80,
                    child: Text(
                      "(${filterSettings._currentRangeValuesAccommodates.start.round()} - ${filterSettings._currentRangeValuesAccommodates.end.round()})",
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (filterSettings._accommodatesChecked == false)
                  Container()
                else
                  Expanded(
                    child: RangeSlider(
                      values: filterSettings._currentRangeValuesAccommodates,
                      min: 1,
                      max: 20,
                      divisions: 19,
                      labels: RangeLabels(
                        filterSettings._currentRangeValuesAccommodates.start
                            .round()
                            .toString(),
                        filterSettings._currentRangeValuesAccommodates.end
                            .round()
                            .toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          filterSettings._currentRangeValuesAccommodates =
                              values;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Checkbox(
                        value: this.filterSettings._propertyTypeChecked,
                        onChanged: (value) {
                          setState(() {
                            this.filterSettings._propertyTypeChecked = value!;
                          });
                        },
                      ),
                      Container(
                        width: 190,
                        child: const Text("Property Type"),
                      ),
                      if (filterSettings._propertyTypeChecked == false)
                        Container()
                      else
                        Expanded(
                          child: buildPropertyType(),
                        ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Checkbox(
                        value: this.filterSettings._roomTypeChecked,
                        onChanged: (value) {
                          setState(() {
                            this.filterSettings._roomTypeChecked = value!;
                          });
                        },
                      ),
                      Container(
                        width: 190,
                        child: const Text("Room Type"),
                      ),
                      if (filterSettings._roomTypeChecked == false)
                        Container()
                      else
                        Expanded(
                          child: buildRoomType(),
                        ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Checkbox(
                        value: this.filterSettings._neighbourhoodChecked,
                        onChanged: (value) {
                          setState(() {
                            this.filterSettings._neighbourhoodChecked = value!;
                          });
                        },
                      ),
                      Container(
                        width: 190,
                        child: const Text("Neighbourhood"),
                      ),
                      if (filterSettings._neighbourhoodChecked == false)
                        Container()
                      else
                        Expanded(
                          child: buildNeighbourhoodType(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => {
              if (formKey.currentState!.validate())
                {
                  formKey.currentState!.save(),
                  _submit(
                      filterSettings, myFlatProvider, myNeighbourhoodProvider)
                }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(
      FilterSettings filterSettings,
      FlatProvider myFlatProvider,
      NeighbourhoodProvider myNeigbourhoodProvider) async {
    setState(() {
      _isLoading = true;
    });
    await myFlatProvider.filterListings(filterSettings);
    await myNeigbourhoodProvider.filterAveragePriceListings(filterSettings);
    setState(() {
      _isLoading = false;
    });
  }
}
