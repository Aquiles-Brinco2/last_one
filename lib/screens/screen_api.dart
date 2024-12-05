import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _id;
  String? _name;
  String? _type;
  String? _ability;
  bool? _status;

  @override
  void initState() {
    super.initState();
    context.read<ApiBlocBloc>().add(FetchApiDataEvent());
  }

  void _showAddEditDialog({Map<String, dynamic>? item}) {
    _id = item?['id'];
    _name = item?['name'];
    _type = item?['type'];
    _ability = item?['ability'];
    _status = item?['status'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Agregar Pokemon' : 'Editar Pokemon'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onSaved: (value) => _name = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                TextFormField(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  onSaved: (value) => _type = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                TextFormField(
                  initialValue: _ability,
                  decoration: const InputDecoration(labelText: 'Habilidad'),
                  onSaved: (value) => _ability = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                SwitchListTile(
                  title: const Text('Estado'),
                  value: _status ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _saveForm,
              child: Text(item == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final data = {
        'name': _name,
        'type': _type,
        'ability': _ability,
        'status': _status ?? false,
      };

      if (_id == null) {
        context.read<ApiBlocBloc>().add(CreateApiDataEvent(data: data));
      } else {
        context
            .read<ApiBlocBloc>()
            .add(UpdateApiDataEvent(id: _id!, updatedData: data));
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon CRUD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditDialog(),
          ),
        ],
      ),
      body: BlocBuilder<ApiBlocBloc, ApiBlocState>(
        builder: (context, state) {
          if (state is ApiLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ApiErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state is ApiLoadedState) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index];
                return Dismissible(
                  key: Key(item['id']),
                  background: Container(color: Colors.red),
                  onDismissed: (_) {
                    context
                        .read<ApiBlocBloc>()
                        .add(DeleteApiDataEvent(id: item['id']));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item['avatar'] ?? ''),
                    ),
                    title: Text(item['name']),
                    subtitle: Text('Tipo: ${item['type']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showAddEditDialog(item: item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Inicializando...'));
        },
      ),
    );
  }
}
