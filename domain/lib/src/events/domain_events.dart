import 'package:data/data.dart';

sealed class DomainEvent extends AppEvent {
  const DomainEvent();
}

class UnauthorizedEvent extends DomainEvent {
  const UnauthorizedEvent();
}
