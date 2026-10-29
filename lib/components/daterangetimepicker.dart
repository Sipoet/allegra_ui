import 'package:flutter/material.dart';

class DateTimeRangeScreen extends StatefulWidget {
  const DateTimeRangeScreen({super.key});

  @override
  State<DateTimeRangeScreen> createState() => _DateTimeRangeScreenState();
}

class _DateTimeRangeScreenState extends State<DateTimeRangeScreen> {
  final TextEditingController _dateTimeRangeController =
      TextEditingController();

  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);

  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 59);

  @override
  void initState() {
    // _updateControllerText();
    super.initState();
  }

  void _updateControllerText() {
    String startStr =
        "${_startDate.day.toString().padLeft(2, '0')}/"
        "${_startDate.month.toString().padLeft(2, '0')}/"
        "${_startDate.year} ${_startTime.format(context)}";

    String endStr =
        "${_endDate.day.toString().padLeft(2, '0')}/"
        "${_endDate.month.toString().padLeft(2, '0')}/"
        "${_endDate.year} ${_endTime.format(context)}";

    _dateTimeRangeController.text = "$startStr  s/d  $endStr";
  }

  // Popup function to pick start and end date/time interactively
  Future<void> _showCustomDateTimeRangePicker(BuildContext context) async {
    // Temporary variables to hold choices inside dialog
    DateTime tempStartDate = _startDate;
    TimeOfDay tempStartTime = _startTime;
    DateTime tempEndDate = _endDate;
    TimeOfDay tempEndTime = _endTime;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Pilih Periode Tanggal & Waktu',
                style: TextStyle(fontSize: 16),
              ),
              content: SizedBox(
                width: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Waktu Mulai (Start)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              "${tempStartDate.day}/${tempStartDate.month}/${tempStartDate.year}",
                            ),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: tempStartDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setDialogState(
                                  () => tempStartDate = pickedDate,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.access_time, size: 16),
                            label: Text(tempStartTime.format(context)),
                            onPressed: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: tempStartTime,
                              );
                              if (pickedTime != null) {
                                setDialogState(
                                  () => tempStartTime = pickedTime,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Waktu Selesai (End)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              "${tempEndDate.day}/${tempEndDate.month}/${tempEndDate.year}",
                            ),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: tempEndDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setDialogState(() => tempEndDate = pickedDate);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.access_time, size: 16),
                            label: Text(tempEndTime.format(context)),
                            onPressed: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: tempEndTime,
                              );
                              if (pickedTime != null) {
                                setDialogState(() => tempEndTime = pickedTime);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startDate = tempStartDate;
                      _startTime = tempStartTime;
                      _endDate = tempEndDate;
                      _endTime = tempEndTime;
                      _updateControllerText();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Periode & Waktu Transaksi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          // Input Field
          SizedBox(
            width: 380,
            child: TextField(
              controller: _dateTimeRangeController,
              readOnly: true, // Prevents manual typing
              onTap: () => _showCustomDateTimeRangePicker(
                context,
              ), // Triggers popup dialog
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () => _showCustomDateTimeRangePicker(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
