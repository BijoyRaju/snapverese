import 'package:flutter/material.dart';

Widget customSearchBar(
  String labelText,
  TextEditingController controller,
  VoidCallback onSearch,
  VoidCallback onChanged,
) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      onSubmitted: (_) => onSearch(),
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: onSearch, 
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.5,
          ),
        ),
      ),
    );
}