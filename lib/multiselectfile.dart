import 'package:flutter/material.dart';

class MyAp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dropdowns",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Multiselect(),
    );
  }
}
// ================== coped from Stack Overflow

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Country'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        ),
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

// ======================== //

class Multiselect extends StatefulWidget {
  @override
  _MultiselectState createState() => _MultiselectState();
}

class _MultiselectState extends State<Multiselect> {
  List<MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    1: "India",
    2: "Britain",
    3: "Russia",
    4: "Canada",
  };

  void populateMultiselect() {
    for (int v in valuestopopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    populateMultiselect();
    final items = multiItem;
    // final items = <MultiSelectDialogItem<int>>[
    //   MultiSelectDialogItem(1, 'India'),
    //   MultiSelectDialogItem(2, 'USA'),
    //   MultiSelectDialogItem(3, 'Canada'),
    // ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          //initialSelectedValues: [1, 2].toSet(),
        );
      },
    );

    print(selectedValues);
    getvaluefromkey(selectedValues);
  }

  String val = '';
  List<String> _value = List();
  void getvaluefromkey(Set selection) {
    if (selection != null) {
      _value = [];
      for (int x in selection.toList()) {
        print(valuestopopulate[x]);
        _value.add(valuestopopulate[x]);
      }
      setState(() {
        val = _value.toString();
      });
    } else {
      setState(() {
        val = "Please select any value";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text('MultiSelect Dropdown'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: RaisedButton(
                child: Text('Select Values'),
                onPressed: () => _showMultiSelect(context),
              ),
            ),
            Text(
              '$val',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
