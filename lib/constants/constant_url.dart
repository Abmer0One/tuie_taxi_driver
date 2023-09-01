

class ConstantUrl {

  //--------------------------- URL MAIN ------------------------------------ -/

  //static const ip = 'http://192.168.1.100/tuie_api';
  static const ip = 'https://tuie.ao/tuie_api';

  //--------------------- REGISTAR PASSAGEIRO ------------------------------- -/
  static const registarPassageiroTuie = '$ip/cliente/registar_passageiro_foto.php';

  //------------------------ SELECIONAR PASSAGEIRO -------------------------- -/
  static const selecionarPassageiro = '$ip/cliente/selecionar_passageiro.php';

  //------------------------ EDITAR PASSAGEIRO ------------------------------ -/
  static const editarPassageiroTuie = '$ip/cliente/editar_passageiro.php';

  //------------------------ CONFIRMAR PASSAGEIRO --------------------------- -/
  static const confirmarPassageiro = '$ip/cliente/confirmar_passageiro.php';

  //------------------------ SOLICITAR CORRIDA ------------------------------ -/
  static const solicitarCorridaPassageiro = '$ip/corrida/registar_corrida_passageiro.php';

  //------------------------ EDITAR CORRIDA ------------------------------ -/
  static const editarCorridaPassageiro = '$ip/corrida/editar_corrida_solicitada_passageiro.php';

  //------------------------ CANCELAR CORRIDA ------------------------------ -/
  static const cancelarCorridaPassageiro = '$ip/corrida/cancelar_corrida_passageiro.php';

  //------------------- SELECIONAR CORRIDA SOLICITADA ----------------------- -/
  static const selecionarCorridaPassageiroSolicitada = '$ip/corrida/corrida_passageiro_solicitada.php';

  //------------------------ SELECIONAR MOTORISTA --------------------------- -/
  static const selecionarMotoristaTuiePorId = '$ip/motorista/selecionar_motorista_tuie_por_id.php';

  //--------------------- SELECIONAR CARRO DO MOTORISTA --------------------- -/
  static const selecionarCarroMotoristaTuie = '$ip/viatura/selecionar_carro_motorista.php';

  //--------------------- SELECIONAR TIPO DE SERVIÇO --------------------- -/
  static const selecionarTipoDeServicoTuie = '$ip/servico/selecionar_tipo_de_servico.php';

  //--------------------- EDITAR PASSAGEIRO FOTO --------------------- -/
  static const editarPassageiroTuieFoto = '$ip/cliente/editar_passageiro.php';

  //--------------------- SELECIONAR MOTORISTAS DA TUE --------------------- -/
  static const selecionarMotoristasTuie = '$ip/motorista/selecionar_todos_motoristas.php';

  //--------------------- SELECIONAR SERVIÇOS DA TUE --------------------- -/
  static const selecionarServicosTuie = '$ip/servico/selecionar_servicos_tuie.php';

}