import 'package:cloud_firestore/cloud_firestore.dart';

class DataImportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUniversities() async {
    final universities = _getUniversitiesData();

    for (final entry in universities.entries) {
      try {
        await _firestore
            .collection('universities')
            .doc(entry.key)
            .set(entry.value);
      } catch (e) {
        throw Exception('Ошибка при добавлении ${entry.key}: $e');
      }
    }
  }

  Map<String, Map<String, dynamic>> _getUniversitiesData() {
    return {
      'kaznu': {
        'name': 'Al-Farabi Kazakh National University',
        'nameRu': 'Казахский национальный университет имени аль-Фараби',
        'nameKz': 'Әл-Фараби атындағы Қазақ ұлттық университеті',
        'description': 'Leading research university in Kazakhstan, founded in 1934',
        'descriptionRu': 'Ведущий исследовательский университет Казахстана, основанный в 1934 году. Один из старейших и наиболее престижных вузов страны.',
        'descriptionKz': '1934 жылы құрылған Қазақстандағы жетекші зерттеу университеті. Елдегі ең ескі және беделді жоғары оқу орындарының бірі.',
        'logoUrl': '',
        'coverImageUrl': '',
        'location': 'Almaty, Kazakhstan',
        'city': 'Алматы',
        'website': 'https://www.kaznu.kz',
        'email': 'info@kaznu.kz',
        'phone': '+7 (727) 377-33-33',
        'rating': 4.8,
        'studentCount': 25000,
        'foundedDate': Timestamp.fromDate(DateTime(1934, 1, 15)),
        'images': [],
        'mission': {
          'text': 'To provide world-class education and conduct cutting-edge research',
          'textRu': 'Обеспечение мирового уровня образования и проведение передовых научных исследований',
          'textKz': 'Әлемдік деңгейдегі білім беру және алдыңғы қатарлы ғылыми зерттеулер жүргізу',
          'vision': 'To become a leading research university in Central Asia',
          'visionRu': 'Стать ведущим исследовательским университетом Центральной Азии',
          'visionKz': 'Орталық Азиядағы жетекші зерттеу университетіне айналу',
          'values': ['Excellence', 'Innovation', 'Integrity', 'Internationalization'],
          'valuesRu': ['Превосходство', 'Инновации', 'Честность', 'Интернационализация'],
          'valuesKz': ['Тамаша', 'Инновациялар', 'Адалдық', 'Интернационализация']
        },
        'history': {
          'text': 'Founded in 1934 as Kazakh State University',
          'textRu': 'Основан в 1934 году как Казахский государственный университет. В 1991 году переименован в честь великого ученого аль-Фараби.',
          'textKz': '1934 жылы Қазақ мемлекеттік университеті ретінде құрылды. 1991 жылы ұлы ғалым Әл-Фараби атында аталды.',
          'events': [
            {
              'year': 1934,
              'description': 'University founded as Kazakh State University',
              'descriptionRu': 'Основан Казахский государственный университет',
              'descriptionKz': 'Қазақ мемлекеттік университеті құрылды'
            },
            {
              'year': 1991,
              'description': 'Renamed after al-Farabi',
              'descriptionRu': 'Переименован в честь аль-Фараби',
              'descriptionKz': 'Әл-Фараби атында аталды'
            }
          ]
        },
        'leadership': {
          'rectorName': 'Galym Mutanov',
          'rectorNameRu': 'Галым Мутанов',
          'rectorNameKz': 'Ғалым Мұтанов',
          'rectorBio': 'Doctor of Technical Sciences, Professor, Academician',
          'rectorBioRu': 'Доктор технических наук, профессор, академик. Руководит университетом с 2007 года.',
          'rectorBioKz': 'Техника ғылымдарының докторы, профессор, академик. 2007 жылдан бастап университетті басқарады.',
          'rectorPhotoUrl': '',
          'leaders': []
        },
        'achievements': [
          {
            'id': 'ach1',
            'title': 'QS World University Rankings',
            'titleRu': 'Рейтинг QS World University Rankings',
            'titleKz': 'QS World University Rankings рейтингі',
            'description': 'Ranked in top 200 universities worldwide',
            'descriptionRu': 'Входит в топ-200 университетов мира по версии QS',
            'descriptionKz': 'QS нұсқасы бойынша әлемдегі топ-200 университеттер қатарына кіреді',
            'imageUrl': '',
            'date': Timestamp.fromDate(DateTime(2023, 6, 1))
          }
        ],
        'academicPrograms': [
          {
            'id': 'prog1',
            'name': 'Computer Science',
            'nameRu': 'Информатика',
            'nameKz': 'Информатика',
            'description': 'Bachelor program in Computer Science and Software Engineering',
            'descriptionRu': 'Программа бакалавриата по информатике и программной инженерии',
            'descriptionKz': 'Информатика және бағдарламалық инженерия бойынша бакалавриат бағдарламасы',
            'degree': 'Bachelor',
            'degreeRu': 'Бакалавр',
            'degreeKz': 'Бакалавр',
            'faculty': 'Faculty of Information Technology',
            'facultyRu': 'Факультет информационных технологий',
            'facultyKz': 'Ақпараттық технологиялар факультеті',
            'duration': 4,
            'language': 'Kazakh, Russian, English',
            'languageRu': 'Казахский, Русский, Английский',
            'languageKz': 'Қазақ, Орыс, Ағылшын',
            'tuitionFee': 500000.0,
            'currency': 'KZT',
            'requirements': [
              'High school diploma',
              'Entrance exam in Mathematics and Physics',
              'English language certificate (for English track)'
            ],
            'requirementsRu': [
              'Аттестат о среднем образовании',
              'Вступительные экзамены по математике и физике',
              'Сертификат по английскому языку (для англоязычного потока)'
            ],
            'requirementsKz': [
              'Орта білім туралы куәлік',
              'Математика және физика бойынша кіру емтихандары',
              'Ағылшын тілі сертификаты (ағылшын тілдік ағым үшін)'
            ],
            'careerOpportunities': [
              'Software Developer',
              'Data Scientist',
              'System Analyst',
              'IT Project Manager'
            ],
            'careerOpportunitiesRu': [
              'Разработчик программного обеспечения',
              'Специалист по данным',
              'Системный аналитик',
              'IT-менеджер проектов'
            ],
            'careerOpportunitiesKz': [
              'Бағдарламалық жасақтаманы дамытушы',
              'Деректер маманы',
              'Жүйелік аналитик',
              'IT-жобалар менеджері'
            ],
            'imageUrl': ''
          }
        ],
        'internationalCooperation': {
          'description': 'Active international cooperation with 300+ partner universities',
          'descriptionRu': 'Активное международное сотрудничество с более чем 300 партнерскими университетами по всему миру',
          'descriptionKz': 'Әлем бойынша 300-ден астам серіктес университеттермен белсенді халықаралық ынтымақтастық',
          'exchangePrograms': [
            {
              'id': 'ex1',
              'name': 'Erasmus+',
              'nameRu': 'Эразмус+',
              'nameKz': 'Эразмус+',
              'description': 'Student exchange program with European universities',
              'descriptionRu': 'Программа обмена студентами с европейскими университетами',
              'descriptionKz': 'Еуропалық университеттермен студенттер алмасу бағдарламасы',
              'country': 'European Union',
              'duration': '1 semester',
              'requirements': 'GPA 3.0+, language certificate',
              'requirementsRu': 'GPA 3.0+, языковой сертификат',
              'requirementsKz': 'GPA 3.0+, тілдік сертификат'
            }
          ],
          'partnerUniversities': [
            {
              'id': 'partner1',
              'name': 'Moscow State University',
              'country': 'Russia',
              'logoUrl': '',
              'website': 'https://www.msu.ru',
              'description': 'Partnership in research and student exchange',
              'descriptionRu': 'Партнерство в области исследований и обмена студентами',
              'descriptionKz': 'Зерттеулер және студенттер алмасу саласындағы серіктестік'
            }
          ],
          'opportunities': [
            {
              'id': 'opp1',
              'title': 'Scholarship for International Students',
              'titleRu': 'Стипендия для иностранных студентов',
              'titleKz': 'Шетелдік студенттерге стипендия',
              'description': 'Full tuition coverage for outstanding international students',
              'descriptionRu': 'Полное покрытие обучения для выдающихся иностранных студентов',
              'descriptionKz': 'Керемет шетелдік студенттерге оқу толық қамтамасыз ету',
              'type': 'scholarship'
            }
          ]
        },
        'admission': {
          'description': 'Admission process and requirements for 2024',
          'descriptionRu': 'Процесс поступления и требования на 2024 год',
          'descriptionKz': '2024 жылға түсу процесі және талаптар',
          'requirements': [
            {
              'id': 'req1',
              'title': 'High School Diploma',
              'titleRu': 'Аттестат о среднем образовании',
              'titleKz': 'Орта білім туралы куәлік',
              'description': 'Original or notarized copy of high school diploma',
              'descriptionRu': 'Оригинал или нотариально заверенная копия аттестата',
              'descriptionKz': 'Аттестаттың түпнұсқасы немесе нотариалды расталған көшірмесі',
              'type': 'document'
            }
          ],
          'procedures': [
            {
              'step': 1,
              'title': 'Submit Application',
              'titleRu': 'Подача заявления',
              'titleKz': 'Өтініш беру',
              'description': 'Submit online application through university website',
              'descriptionRu': 'Подать заявление онлайн через сайт университета',
              'descriptionKz': 'Университет сайты арқылы онлайн өтініш беру'
            },
            {
              'step': 2,
              'title': 'Take Entrance Exam',
              'titleRu': 'Сдать вступительные экзамены',
              'titleKz': 'Кіру емтихандарын тапсыру',
              'description': 'Pass entrance examinations in required subjects',
              'descriptionRu': 'Сдать вступительные экзамены по требуемым предметам',
              'descriptionKz': 'Талап етілетін пәндер бойынша кіру емтихандарын тапсыру'
            }
          ],
          'deadlines': [
            {
              'id': 'deadline1',
              'program': 'Bachelor Programs',
              'programRu': 'Программы бакалавриата',
              'programKz': 'Бакалавриат бағдарламалары',
              'deadline': Timestamp.fromDate(DateTime(2024, 7, 15)),
              'type': 'application'
            }
          ],
          'scholarships': [
            {
              'id': 'sch1',
              'name': 'Presidential Scholarship',
              'nameRu': 'Президентская стипендия',
              'nameKz': 'Президенттік стипендия',
              'description': 'Full tuition coverage for outstanding students',
              'descriptionRu': 'Полное покрытие обучения для выдающихся студентов',
              'descriptionKz': 'Керемет студенттерге оқу толық қамтамасыз ету',
              'amount': 100000.0,
              'currency': 'KZT',
              'coverage': 'Full tuition + monthly stipend',
              'coverageRu': 'Полное покрытие обучения + ежемесячная стипендия',
              'coverageKz': 'Оқу толық қамтамасыз ету + ай сайынғы стипендия',
              'requirements': ['GPA 3.8+', 'Active participation in research'],
              'requirementsRu': ['GPA 3.8+', 'Активное участие в научных исследованиях'],
              'requirementsKz': ['GPA 3.8+', 'Ғылыми зерттеулерде белсенді қатысу']
            }
          ],
          'financialAid': {
            'description': 'Various financial aid options available',
            'descriptionRu': 'Доступны различные варианты финансовой помощи',
            'descriptionKz': 'Қаржылық көмектің әртүрлі нұсқалары қолжетімді',
            'options': ['Student loans with low interest', 'Payment plans'],
            'optionsRu': ['Студенческие займы с низкой процентной ставкой', 'Планы оплаты'],
            'optionsKz': ['Төмен пайыздық мөлшерлемесі бар студенттік несиелер', 'Төлем жоспарлары']
          }
        },
        'tour3dUrl': ''
      },
      'kbtu': {
        'name': 'Kazakh-British Technical University',
        'nameRu': 'Казахско-Британский технический университет',
        'nameKz': 'Қазақ-Британ техникалық университеті',
        'description': 'Leading technical university in Kazakhstan',
        'descriptionRu': 'Ведущий технический университет Казахстана, специализирующийся на инженерии и технологиях',
        'descriptionKz': 'Инженерия мен технологияларға маманданған Қазақстандағы жетекші техникалық университет',
        'logoUrl': '',
        'coverImageUrl': '',
        'location': 'Almaty, Kazakhstan',
        'city': 'Алматы',
        'website': 'https://www.kbtu.kz',
        'email': 'info@kbtu.kz',
        'phone': '+7 (727) 357-42-27',
        'rating': 4.7,
        'studentCount': 8000,
        'foundedDate': Timestamp.fromDate(DateTime(2001, 1, 1)),
        'images': [],
        'mission': {
          'text': 'To provide world-class technical education',
          'textRu': 'Обеспечение технического образования мирового уровня',
          'textKz': 'Әлемдік деңгейдегі техникалық білім беру',
          'vision': 'To become a leading technical university in Central Asia',
          'visionRu': 'Стать ведущим техническим университетом Центральной Азии',
          'visionKz': 'Орталық Азиядағы жетекші техникалық университетіне айналу',
          'values': ['Innovation', 'Excellence', 'Practical Skills'],
          'valuesRu': ['Инновации', 'Превосходство', 'Практические навыки'],
          'valuesKz': ['Инновациялар', 'Тамаша', 'Практикалық дағдылар']
        },
        'history': {
          'text': 'Founded in 2001 as a joint Kazakh-British project',
          'textRu': 'Основан в 2001 году как совместный казахско-британский проект',
          'textKz': '2001 жылы қазақ-британдық бірлескен жоба ретінде құрылды',
          'events': [
            {
              'year': 2001,
              'description': 'University founded',
              'descriptionRu': 'Основан университет',
              'descriptionKz': 'Университет құрылды'
            }
          ]
        },
        'leadership': {
          'rectorName': 'Kuanyshbek Yessekeyev',
          'rectorNameRu': 'Куанышбек Есекеев',
          'rectorNameKz': 'Қуанышбек Есекеев',
          'rectorBio': 'Doctor of Technical Sciences',
          'rectorBioRu': 'Доктор технических наук',
          'rectorBioKz': 'Техника ғылымдарының докторы',
          'rectorPhotoUrl': '',
          'leaders': []
        },
        'achievements': [],
        'academicPrograms': [
          {
            'id': 'prog1',
            'name': 'Petroleum Engineering',
            'nameRu': 'Нефтегазовое дело',
            'nameKz': 'Мұнай-газ ісі',
            'description': 'Bachelor program in Petroleum Engineering',
            'descriptionRu': 'Программа бакалавриата по нефтегазовому делу',
            'descriptionKz': 'Мұнай-газ ісі бойынша бакалавриат бағдарламасы',
            'degree': 'Bachelor',
            'degreeRu': 'Бакалавр',
            'degreeKz': 'Бакалавр',
            'faculty': 'School of Energy and Oil & Gas Industry',
            'facultyRu': 'Школа энергетики и нефтегазовой промышленности',
            'facultyKz': 'Энергетика және мұнай-газ өнеркәсібі мектебі',
            'duration': 4,
            'language': 'English',
            'languageRu': 'Английский',
            'languageKz': 'Ағылшын',
            'tuitionFee': 1200000.0,
            'currency': 'KZT',
            'requirements': ['High school diploma', 'IELTS 6.0+', 'Entrance exam in Mathematics and Physics'],
            'requirementsRu': ['Аттестат о среднем образовании', 'IELTS 6.0+', 'Вступительные экзамены по математике и физике'],
            'requirementsKz': ['Орта білім туралы куәлік', 'IELTS 6.0+', 'Математика және физика бойынша кіру емтихандары'],
            'careerOpportunities': ['Petroleum Engineer', 'Drilling Engineer', 'Reservoir Engineer'],
            'careerOpportunitiesRu': ['Инженер-нефтяник', 'Инженер по бурению', 'Инженер по разработке месторождений'],
            'careerOpportunitiesKz': ['Мұнай инженері', 'Бұрғылау инженері', 'Кен орындарын игеру инженері'],
            'imageUrl': ''
          }
        ],
        'internationalCooperation': {
          'description': 'Partnership with British universities',
          'descriptionRu': 'Партнерство с британскими университетами',
          'descriptionKz': 'Британдық университеттермен серіктестік',
          'exchangePrograms': [],
          'partnerUniversities': [],
          'opportunities': []
        },
        'admission': {
          'description': 'Admission information',
          'descriptionRu': 'Информация о поступлении',
          'descriptionKz': 'Түсу ақпараты',
          'requirements': [],
          'procedures': [],
          'deadlines': [],
          'scholarships': [],
          'financialAid': {
            'description': '',
            'descriptionRu': '',
            'descriptionKz': '',
            'options': [],
            'optionsRu': [],
            'optionsKz': []
          }
        },
        'tour3dUrl': ''
      },
      'enu': {
        'name': 'L.N. Gumilyov Eurasian National University',
        'nameRu': 'Евразийский национальный университет имени Л.Н. Гумилева',
        'nameKz': 'Л.Н. Гумилев атындағы Еуразия ұлттық университеті',
        'description': 'Leading university in Astana',
        'descriptionRu': 'Ведущий университет Астаны, основанный в 1996 году',
        'descriptionKz': '1996 жылы құрылған Астанадағы жетекші университет',
        'logoUrl': '',
        'coverImageUrl': '',
        'location': 'Astana, Kazakhstan',
        'city': 'Астана',
        'website': 'https://www.enu.kz',
        'email': 'info@enu.kz',
        'phone': '+7 (7172) 70-95-10',
        'rating': 4.6,
        'studentCount': 15000,
        'foundedDate': Timestamp.fromDate(DateTime(1996, 5, 23)),
        'images': [],
        'mission': {
          'text': 'To provide quality education',
          'textRu': 'Обеспечение качественного образования',
          'textKz': 'Сапалы білім беру',
          'vision': 'Leading university in Kazakhstan',
          'visionRu': 'Ведущий университет Казахстана',
          'visionKz': 'Қазақстандағы жетекші университет',
          'values': ['Quality', 'Innovation'],
          'valuesRu': ['Качество', 'Инновации'],
          'valuesKz': ['Сапа', 'Инновациялар']
        },
        'history': {
          'text': 'Founded in 1996',
          'textRu': 'Основан в 1996 году',
          'textKz': '1996 жылы құрылды',
          'events': []
        },
        'leadership': {
          'rectorName': 'Yerlan Sydykov',
          'rectorNameRu': 'Ерлан Сыдыков',
          'rectorNameKz': 'Ерлан Сыдықов',
          'rectorBio': 'Doctor of Sciences',
          'rectorBioRu': 'Доктор наук',
          'rectorBioKz': 'Ғылым докторы',
          'rectorPhotoUrl': '',
          'leaders': []
        },
        'achievements': [],
        'academicPrograms': [
          {
            'id': 'prog1',
            'name': 'Economics',
            'nameRu': 'Экономика',
            'nameKz': 'Экономика',
            'description': 'Bachelor program in Economics',
            'descriptionRu': 'Программа бакалавриата по экономике',
            'descriptionKz': 'Экономика бойынша бакалавриат бағдарламасы',
            'degree': 'Bachelor',
            'degreeRu': 'Бакалавр',
            'degreeKz': 'Бакалавр',
            'faculty': 'Faculty of Economics',
            'facultyRu': 'Экономический факультет',
            'facultyKz': 'Экономикалық факультет',
            'duration': 4,
            'language': 'Kazakh, Russian',
            'languageRu': 'Казахский, Русский',
            'languageKz': 'Қазақ, Орыс',
            'tuitionFee': 400000.0,
            'currency': 'KZT',
            'requirements': ['High school diploma', 'Entrance exam'],
            'requirementsRu': ['Аттестат о среднем образовании', 'Вступительные экзамены'],
            'requirementsKz': ['Орта білім туралы куәлік', 'Кіру емтихандары'],
            'careerOpportunities': ['Economist', 'Financial Analyst'],
            'careerOpportunitiesRu': ['Экономист', 'Финансовый аналитик'],
            'careerOpportunitiesKz': ['Экономист', 'Қаржылық аналитик'],
            'imageUrl': ''
          }
        ],
        'internationalCooperation': {
          'description': '',
          'descriptionRu': '',
          'descriptionKz': '',
          'exchangePrograms': [],
          'partnerUniversities': [],
          'opportunities': []
        },
        'admission': {
          'description': '',
          'descriptionRu': '',
          'descriptionKz': '',
          'requirements': [],
          'procedures': [],
          'deadlines': [],
          'scholarships': [],
          'financialAid': {
            'description': '',
            'descriptionRu': '',
            'descriptionKz': '',
            'options': [],
            'optionsRu': [],
            'optionsKz': []
          }
        },
        'tour3dUrl': ''
      },
      'kimep': {
        'name': 'KIMEP University',
        'nameRu': 'Университет КИМЭП',
        'nameKz': 'КИМЭП университеті',
        'description': 'Leading business university in Kazakhstan',
        'descriptionRu': 'Ведущий бизнес-университет Казахстана, специализирующийся на бизнесе и экономике',
        'descriptionKz': 'Бизнес пен экономикаға маманданған Қазақстандағы жетекші бизнес-университет',
        'logoUrl': '',
        'coverImageUrl': '',
        'location': 'Almaty, Kazakhstan',
        'city': 'Алматы',
        'website': 'https://www.kimep.kz',
        'email': 'info@kimep.kz',
        'phone': '+7 (727) 270-42-00',
        'rating': 4.5,
        'studentCount': 5000,
        'foundedDate': Timestamp.fromDate(DateTime(1992, 1, 1)),
        'images': [],
        'mission': {
          'text': 'To provide world-class business education',
          'textRu': 'Обеспечение бизнес-образования мирового уровня',
          'textKz': 'Әлемдік деңгейдегі бизнес-білім беру',
          'vision': 'Leading business school in Central Asia',
          'visionRu': 'Ведущая бизнес-школа Центральной Азии',
          'visionKz': 'Орталық Азиядағы жетекші бизнес-мектебі',
          'values': ['Business Excellence', 'Innovation'],
          'valuesRu': ['Превосходство в бизнесе', 'Инновации'],
          'valuesKz': ['Бизнесте тамаша', 'Инновациялар']
        },
        'history': {
          'text': 'Founded in 1992',
          'textRu': 'Основан в 1992 году',
          'textKz': '1992 жылы құрылды',
          'events': []
        },
        'leadership': {
          'rectorName': 'Chan Young Bang',
          'rectorNameRu': 'Чан Ён Бан',
          'rectorNameKz': 'Чан Ён Бан',
          'rectorBio': 'President of KIMEP University',
          'rectorBioRu': 'Президент университета КИМЭП',
          'rectorBioKz': 'КИМЭП университетінің президенті',
          'rectorPhotoUrl': '',
          'leaders': []
        },
        'achievements': [],
        'academicPrograms': [
          {
            'id': 'prog1',
            'name': 'Business Administration',
            'nameRu': 'Бизнес-администрирование',
            'nameKz': 'Бизнес-администрирование',
            'description': 'MBA program',
            'descriptionRu': 'Программа MBA',
            'descriptionKz': 'MBA бағдарламасы',
            'degree': 'Master',
            'degreeRu': 'Магистр',
            'degreeKz': 'Магистр',
            'faculty': 'Bang College of Business',
            'facultyRu': 'Бизнес-колледж Банга',
            'facultyKz': 'Бан бизнес-колледжі',
            'duration': 2,
            'language': 'English',
            'languageRu': 'Английский',
            'languageKz': 'Ағылшын',
            'tuitionFee': 2000000.0,
            'currency': 'KZT',
            'requirements': ['Bachelor degree', 'GMAT or GRE', 'Work experience', 'IELTS 6.5+'],
            'requirementsRu': ['Диплом бакалавра', 'GMAT или GRE', 'Опыт работы', 'IELTS 6.5+'],
            'requirementsKz': ['Бакалавр дипломы', 'GMAT немесе GRE', 'Жұмыс тәжірибесі', 'IELTS 6.5+'],
            'careerOpportunities': ['Business Manager', 'Entrepreneur', 'Consultant'],
            'careerOpportunitiesRu': ['Бизнес-менеджер', 'Предприниматель', 'Консультант'],
            'careerOpportunitiesKz': ['Бизнес-менеджер', 'Кәсіпкер', 'Кеңесші'],
            'imageUrl': ''
          }
        ],
        'internationalCooperation': {
          'description': '',
          'descriptionRu': '',
          'descriptionKz': '',
          'exchangePrograms': [],
          'partnerUniversities': [],
          'opportunities': []
        },
        'admission': {
          'description': '',
          'descriptionRu': '',
          'descriptionKz': '',
          'requirements': [],
          'procedures': [],
          'deadlines': [],
          'scholarships': [],
          'financialAid': {
            'description': '',
            'descriptionRu': '',
            'descriptionKz': '',
            'options': [],
            'optionsRu': [],
            'optionsKz': []
          }
        },
        'tour3dUrl': ''
      },
      'sdu': {
        'name': 'Suleyman Demirel University',
        'nameRu': 'Университет имени Сулеймана Демиреля',
        'nameKz': 'Сүлейман Демирел атындағы университет',
        'description': 'Private university in Kaskelen',
        'descriptionRu': 'Частный университет в Каскелене, основанный в 1996 году',
        'descriptionKz': '1996 жылы құрылған Қаскелендегі жеке университет',
        'logoUrl': '',
        'coverImageUrl': '',
        'location': 'Kaskelen, Kazakhstan',
        'city': 'Қаскелен',
        'website': 'https://www.sdu.edu.kz',
        'email': 'info@sdu.edu.kz',
        'phone': '+7 (727) 307-95-60',
        'rating': 4.4,
        'studentCount': 12000,
        'foundedDate': Timestamp.fromDate(DateTime(1996, 1, 1)),
        'images': [],
        'mission': {
          'text': 'To provide quality education',
          'textRu': 'Обеспечение качественного образования',
          'textKz': 'Сапалы білім беру',
          'vision': 'Leading private university',
          'visionRu': 'Ведущий частный университет',
          'visionKz': 'Жетекші жеке университет',
          'values': ['Quality', 'Innovation'],
          'valuesRu': ['Качество', 'Инновации'],
          'valuesKz': ['Сапа', 'Инновациялар']
        },
        'history': {
          'text': 'Founded in 1996',
          'textRu': 'Основан в 1996 году',
          'textKz': '1996 жылы құрылды',
          'events': []
        },
        'leadership': {
          'rectorName': 'Assylbek Kozhakhmetov',
          'rectorNameRu': 'Асылбек Кожахметов',
          'rectorNameKz': 'Асылбек Қожахметов',
          'rectorBio': 'Rector of SDU',
          'rectorBioRu': 'Ректор СДУ',
          'rectorBioKz': 'СДУ ректоры',
          'rectorPhotoUrl': '',
          'leaders': []
        },
        'achievements': [],
        'academicPrograms': [
          {
            'id': 'prog1',
            'name': 'Computer Science',
            'nameRu': 'Информатика',
            'nameKz': 'Информатика',
            'description': 'Bachelor program in Computer Science',
            'descriptionRu': 'Программа бакалавриата по информатике',
            'descriptionKz': 'Информатика бойынша бакалавриат бағдарламасы',
            'degree': 'Bachelor',
            'degreeRu': 'Бакалавр',
            'degreeKz': 'Бакалавр',
            'faculty': 'School of Engineering',
            'facultyRu': 'Инженерная школа',
            'facultyKz': 'Инженерлік мектебі',
            'duration': 4,
            'language': 'Kazakh, Russian, English',
            'languageRu': 'Казахский, Русский, Английский',
            'languageKz': 'Қазақ, Орыс, Ағылшын',
            'tuitionFee': 600000.0,
            'currency': 'KZT',
            'requirements': ['High school diploma', 'Entrance exam'],
            'requirementsRu': ['Аттестат о среднем образовании', 'Вступительные экзамены'],
            'requirementsKz': ['Орта білім туралы куәлік', 'Кіру емтихандары'],
            'careerOpportunities': ['Software Developer', 'IT Specialist'],
            'careerOpportunitiesRu': ['Разработчик ПО', 'IT-специалист'],
            'careerOpportunitiesKz': ['БА дамытушы', 'IT-маман'],
            'imageUrl': ''
          }
        ],
        'internationalCooperation': {
          'description': '',
          'descriptionRu': '',
          'descriptionKz': '',
          'exchangePrograms': [],
          'partnerUniversities': [],
          'opportunities': []
        },
        'admission': {
          'description': '',
          'descriptionRu': '',
          'descriptionKz': '',
          'requirements': [],
          'procedures': [],
          'deadlines': [],
          'scholarships': [],
          'financialAid': {
            'description': '',
            'descriptionRu': '',
            'descriptionKz': '',
            'options': [],
            'optionsRu': [],
            'optionsKz': []
          }
        },
        'tour3dUrl': ''
      }
    };
  }
}

