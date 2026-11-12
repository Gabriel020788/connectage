class WellnessSuggestion {
  const WellnessSuggestion({
    required this.title,
    required this.description,
    required this.imageIndex,
    required this.benefits,
    required this.howTo,
    required this.attention,
  });

  final String title;
  final String description;
  final int imageIndex;
  final List<String> benefits;
  final List<String> howTo;
  final String attention;
}

List<WellnessSuggestion> wellnessSuggestionsForAge(int? age) {
  final ageText = age == null ? '' : ' para sua fase de vida';

  return [
    WellnessSuggestion(
      title: 'Movimente-se com segurança',
      description:
          'Uma caminhada leve pode ajudar a manter uma rotina ativa$ageText.',
      imageIndex: 0,
      benefits: const [
        'Pode contribuir para mobilidade, condicionamento e autonomia no dia a dia.',
        'Ajuda a reduzir longos períodos de sedentarismo.',
        'Pode favorecer disposição e bem-estar quando feita de forma regular.',
      ],
      howTo: const [
        'Comece com poucos minutos e aumente aos poucos, respeitando seus limites.',
        'Prefira locais planos, conhecidos e bem iluminados.',
        'Use calçado confortável e faça pausas quando precisar.',
      ],
      attention:
          'Se houver dor forte, falta de ar fora do habitual, tontura ou orientação médica para restrição de esforço, interrompa a atividade e procure avaliação profissional.',
    ),
    const WellnessSuggestion(
      title: 'Mantenha-se hidratado',
      description:
          'Deixe água por perto e distribua a hidratação ao longo do dia.',
      imageIndex: 1,
      benefits: [
        'A hidratação adequada participa do funcionamento normal do organismo.',
        'Pode ajudar a manter conforto, atenção e disposição ao longo do dia.',
        'Criar uma rotina facilita lembrar de beber líquidos regularmente.',
      ],
      howTo: [
        'Mantenha uma garrafa ou copo de água em local visível.',
        'Associe a hidratação a momentos da rotina, como refeições e pausas.',
        'Use os lembretes do ConnectAge se costuma esquecer de beber água.',
      ],
      attention:
          'Não existe uma quantidade única ideal para todas as pessoas. Quem tem restrição de líquidos por orientação médica deve seguir a recomendação do profissional de saúde.',
    ),
    const WellnessSuggestion(
      title: 'Alongue-se com calma',
      description:
          'Movimentos leves e confortáveis podem quebrar longos períodos sentado.',
      imageIndex: 2,
      benefits: [
        'Pode ajudar a manter mobilidade e conforto nos movimentos cotidianos.',
        'É uma forma simples de interromper períodos prolongados na mesma posição.',
        'Pode fazer parte de uma rotina de movimento leve e regular.',
      ],
      howTo: [
        'Faça movimentos lentos, sem balanços bruscos.',
        'Evite forçar até sentir dor; procure apenas uma sensação confortável de alongamento.',
        'Use apoio de cadeira ou parede quando isso trouxer mais segurança.',
      ],
      attention:
          'Alongamentos não devem causar dor intensa. Em caso de limitação importante, lesão recente ou orientação específica, adapte os movimentos com ajuda profissional.',
    ),
    const WellnessSuggestion(
      title: 'Cuide do seu sono',
      description:
          'Tente manter horários regulares para dormir e acordar.',
      imageIndex: 3,
      benefits: [
        'Uma rotina de sono regular pode favorecer disposição e atenção durante o dia.',
        'O descanso adequado participa do bem-estar físico e emocional.',
        'Hábitos consistentes ajudam o corpo a reconhecer os horários de descanso.',
      ],
      howTo: [
        'Tente manter horários parecidos para dormir e acordar.',
        'Reduza estímulos intensos próximo ao horário de dormir.',
        'Mantenha o quarto confortável, silencioso e com pouca luz quando possível.',
      ],
      attention:
          'Ronco intenso, pausas respiratórias percebidas, sonolência excessiva ou insônia persistente merecem avaliação de um profissional de saúde.',
    ),
    const WellnessSuggestion(
      title: 'Conecte-se com quem importa',
      description:
          'Uma ligação ou videochamada também faz parte de uma rotina de bem-estar.',
      imageIndex: 4,
      benefits: [
        'Manter vínculos pode contribuir para bem-estar emocional e sensação de apoio.',
        'Conversas regulares ajudam a manter contato com familiares e amigos.',
        'Atividades sociais podem tornar a rotina mais agradável e significativa.',
      ],
      howTo: [
        'Combine um horário regular para falar com alguém próximo.',
        'Use o cadastro de pessoa de confiança do ConnectAge para facilitar o contato.',
        'Quando possível, participe de atividades sociais de que você goste.',
      ],
      attention:
          'Se houver tristeza persistente, isolamento intenso ou sofrimento emocional importante, conversar com alguém de confiança e buscar apoio profissional pode ser importante.',
    ),
  ];
}
