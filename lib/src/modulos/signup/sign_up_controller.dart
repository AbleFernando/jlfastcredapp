import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum FormSteps {
  none,
  whoIAm,
  findConsultant,
  consultant,
  bankInfo,
  documents,
  done,
}

// Um controller é responsável por receber as requisições dos usuários
// (geralmente da camada de apresentação, como uma interface de usuário)
// e interagir com os services para processar essas requisições,
// retornando as respostas adequadas.
// Interage com a interface do usuário e coordena as requisições com os serviços.
class SignUpController with MessageStateMixin {
  final _step = ValueSignal(FormSteps.none);
  FormSteps get step => _step();

  var _model = Users.empty();
  Users get model => _model;

  void startProcess() {
    // _step.forceUpdate(FormSteps.whoIAm);
    _step.forceUpdate(FormSteps.findConsultant);
  }

  void setWhoIAmDataStepAndNext(String cpf) {
    _model = _model.copyWith(cpf: cpf);
    _step.forceUpdate(FormSteps.findConsultant);
  }

  void clearForm() {
    _model = _model.clear();
  }

  void goToFormConsultant(Users? users) {
    // _model = users!.copyWith(name: 'Testado');
    if (users != null) {
      _model = users;
    } else {
      _model = Users.empty();
    }

    _step.forceUpdate(FormSteps.consultant);
  }

  void updatePatientAndGoDocumento(Users? consultor) {
    _model = consultor!;
    _step.forceUpdate(FormSteps.documents);
  }
}
