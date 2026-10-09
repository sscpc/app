import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const FocusAIApp());

const bg = Color(0xFF08080D);
const panel = Color(0xFF17131F);
const violet = Color(0xFF6D28D9);
const cyan = Color(0xFF54F4E8);
const lilac = Color(0xFFB7A0FF);
const textColor = Color(0xFFF0EDF7);

class FocusAIApp extends StatelessWidget {
  const FocusAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOCUS AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: violet,
          secondary: cyan,
          surface: panel,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainShell(),
    );
  }
}

class StudyTask {
  StudyTask(this.title, {this.subject = 'General', this.done = false});
  String title;
  String subject;
  bool done;
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selected = 0;
  int completedFocusSessions = 0;
  final List<StudyTask> tasks = [
    StudyTask('Review biology notes', subject: 'Biology'),
    StudyTask('Complete mathematics practice', subject: 'Mathematics'),
    StudyTask('Read 10 pages', subject: 'English'),
    StudyTask('Prepare for tomorrow', subject: 'Planning'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        tasks: tasks,
        sessions: completedFocusSessions,
        onGo: (i) => setState(() => selected = i),
        onTaskChanged: (task, value) => setState(() => task.done = value ?? false),
      ),
      PlannerPage(
        tasks: tasks,
        onTaskChanged: (task, value) => setState(() => task.done = value ?? false),
        onAdd: _addTask,
      ),
      FocusPage(onSessionComplete: () => setState(() => completedFocusSessions++)),
      const AssistantPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: selected, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF100D16),
        indicatorColor: violet.withOpacity(.35),
        selectedIndex: selected,
        onDestinationSelected: (i) => setState(() => selected = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), label: 'Planner'),
          NavigationDestination(icon: Icon(Icons.timer_outlined), selectedIcon: Icon(Icons.timer), label: 'Focus'),
          NavigationDestination(icon: Icon(Icons.smart_toy_outlined), selectedIcon: Icon(Icons.smart_toy), label: 'AI'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Future<void> _addTask() async {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final result = await showDialog<StudyTask>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: panel,
        title: const Text('Add a study task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, autofocus: true, decoration: const InputDecoration(labelText: 'Task name')),
            const SizedBox(height: 12),
            TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject (optional)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                Navigator.pop(context, StudyTask(title, subject: subjectController.text.trim().isEmpty ? 'General' : subjectController.text.trim()));
              }
            },
            child: const Text('Add task'),
          ),
        ],
      ),
    );
    if (result != null && mounted) setState(() => tasks.add(result));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.tasks, required this.sessions, required this.onGo, required this.onTaskChanged});
  final List<StudyTask> tasks;
  final int sessions;
  final ValueChanged<int> onGo;
  final void Function(StudyTask, bool?) onTaskChanged;

  @override
  Widget build(BuildContext context) {
    final done = tasks.where((t) => t.done).length;
    final progress = tasks.isEmpty ? 0.0 : done / tasks.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Row(children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [violet, Color(0xFF30145C)]), borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.psychology_alt, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('FOCUS AI', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            Text('YOUR PERSONAL STUDY COMPANION', style: TextStyle(color: lilac, fontSize: 9, letterSpacing: 1.1)),
          ])),
          IconButton(onPressed: () => onGo(4), icon: const Icon(Icons.account_circle_outlined, color: cyan, size: 29)),
        ]),
        const SizedBox(height: 30),
        const Text('YOUR DAY, UNDER CONTROL.', style: TextStyle(color: cyan, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Ready to focus?', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800, height: 1.1)),
        const SizedBox(height: 8),
        const Text('Small steps. Big achievements.', style: TextStyle(color: lilac, fontSize: 14)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF28144B), panel, Color(0xFF101B27)]),
            border: Border.all(color: violet.withOpacity(.65)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text("TODAY'S PROGRESS", style: TextStyle(color: lilac, fontSize: 11, letterSpacing: 1.3, fontWeight: FontWeight.bold))),
              const Icon(Icons.auto_awesome, color: cyan),
            ]),
            const SizedBox(height: 16),
            Text('$done of ${tasks.length} tasks completed', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 13),
            ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: Colors.white12, color: cyan)),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton.icon(
              onPressed: () => onGo(2),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start studying'),
              style: FilledButton.styleFrom(backgroundColor: violet, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
            )),
          ]),
        ),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: _FeatureCard(icon: Icons.check_circle_outline, title: 'My Tasks', subtitle: '$done completed', onTap: () => onGo(1))),
          const SizedBox(width: 12),
          Expanded(child: _FeatureCard(icon: Icons.smart_toy_outlined, title: 'AI Assistant', subtitle: 'Ask for help', onTap: () => onGo(3))),
        ]),
        const SizedBox(height: 24),
        Row(children: [
          const Expanded(child: Text('UP NEXT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.4))),
          TextButton(onPressed: () => onGo(1), child: const Text('View all')),
        ]),
        ...tasks.where((t) => !t.done).take(3).map((t) => _TaskTile(task: t, onChanged: onTaskChanged)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            const Icon(Icons.local_fire_department, color: cyan, size: 30),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Your focus journey', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('$sessions completed focus sessions', style: const TextStyle(color: lilac, fontSize: 12)),
            ])),
          ]),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: cyan, size: 26),
        const SizedBox(height: 18),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: lilac, fontSize: 12)),
      ]),
    ),
  );
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.onChanged});
  final StudyTask task;
  final void Function(StudyTask, bool?) onChanged;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(15)),
    child: CheckboxListTile(
      value: task.done,
      onChanged: (v) => onChanged(task, v),
      activeColor: violet,
      title: Text(task.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text(task.subject, style: const TextStyle(color: lilac, fontSize: 11)),
      controlAffinity: ListTileControlAffinity.leading,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key, required this.tasks, required this.onTaskChanged, required this.onAdd});
  final List<StudyTask> tasks;
  final void Function(StudyTask, bool?) onTaskChanged;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const _PageHeader(title: 'Study planner', subtitle: 'Make time for what matters.'),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: Text('${tasks.where((t) => !t.done).length} tasks remaining', style: const TextStyle(color: lilac))),
        FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Add task')),
      ]),
      const SizedBox(height: 16),
      ...tasks.map((t) => _TaskTile(task: t, onChanged: onTaskChanged)),
      if (tasks.isEmpty) const Text('No tasks yet. Add your first study task.', style: TextStyle(color: lilac)),
    ],
  );
}

class FocusPage extends StatefulWidget {
  const FocusPage({super.key, required this.onSessionComplete});
  final VoidCallback onSessionComplete;
  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  static const int sessionLength = 25 * 60;
  int remaining = sessionLength;
  Timer? timer;
  bool running = false;
  bool finished = false;
  @override
  void dispose() { timer?.cancel(); super.dispose(); }
  String get clock => '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}';
  void toggle() {
    if (running) {
      timer?.cancel();
      setState(() => running = false);
    } else {
      setState(() { running = true; finished = false; });
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remaining <= 1) {
          t.cancel();
          setState(() { remaining = 0; running = false; finished = true; });
          widget.onSessionComplete();
        } else {
          setState(() => remaining--);
        }
      });
    }
  }
  void reset() { timer?.cancel(); setState(() { remaining = sessionLength; running = false; finished = false; }); }
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const _PageHeader(title: 'Deep focus', subtitle: 'One thing at a time. You’ve got this.'),
      const SizedBox(height: 36),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(28), border: Border.all(color: violet.withOpacity(.6))),
        child: Column(children: [
          const Text('POMODORO SESSION', style: TextStyle(color: cyan, letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 28),
          Container(
            width: 220, height: 220,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: violet, width: 7), boxShadow: [BoxShadow(color: violet.withOpacity(.25), blurRadius: 35)]),
            child: Center(child: Text(clock, style: const TextStyle(fontSize: 49, fontWeight: FontWeight.w300, letterSpacing: 2))),
          ),
          const SizedBox(height: 22),
          Text(finished ? 'Session complete! Great work.' : running ? 'Stay present. Stay focused.' : 'Ready when you are.', style: const TextStyle(color: lilac)),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: FilledButton.icon(onPressed: toggle, icon: Icon(running ? Icons.pause : Icons.play_arrow), label: Text(running ? 'Pause' : 'Start'), style: FilledButton.styleFrom(backgroundColor: violet, padding: const EdgeInsets.symmetric(vertical: 14)))),
            const SizedBox(width: 12),
            OutlinedButton.icon(onPressed: reset, icon: const Icon(Icons.refresh), label: const Text('Reset'), style: OutlinedButton.styleFrom(foregroundColor: cyan, padding: const EdgeInsets.symmetric(vertical: 14))),
          ]),
        ]),
      ),
      const SizedBox(height: 18),
      const Row(children: [
        Expanded(child: _MiniInfo(title: 'FOCUS', value: '25 min')),
        SizedBox(width: 10),
        Expanded(child: _MiniInfo(title: 'SHORT BREAK', value: '5 min')),
      ]),
      const SizedBox(height: 14),
      const Text('This starter uses a 25-minute focus timer. Break switching can be added next.', style: TextStyle(color: lilac, fontSize: 12)),
    ],
  );
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.title, required this.value});
  final String title, value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: lilac, fontSize: 10, letterSpacing: 1)),
      const SizedBox(height: 8),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    ]),
  );
}

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});
  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final input = TextEditingController();
  final List<Map<String, String>> messages = [
    {'from': 'ai', 'text': 'Hi! I’m your study companion. Ask me for study tips, revision ideas, or help planning your next session.'},
  ];
  @override
  void dispose() { input.dispose(); super.dispose(); }
  void send() {
    final q = input.text.trim();
    if (q.isEmpty) return;
    setState(() {
      messages.add({'from': 'you', 'text': q});
      messages.add({'from': 'ai', 'text': _demoReply(q)});
      input.clear();
    });
  }
  String _demoReply(String q) {
    final s = q.toLowerCase();
    if (s.contains('plan') || s.contains('schedule')) return 'Try this: choose one priority, study for 25 minutes, take a 5-minute break, then review what you learned. Add your deadlines in Planner.';
    if (s.contains('focus') || s.contains('distract')) return 'Put your phone on Do Not Disturb, keep only the materials you need nearby, and start one 25-minute focus session.';
    if (s.contains('tired') || s.contains('break')) return 'Take a short break, drink some water, and stretch. Return with one small, clear goal.';
    return 'Good question! This starter assistant uses sample replies only. Connect an AI API to enable real answers. For now, try asking for a study plan or focus tips.';
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 12), child: _PageHeader(title: 'AI assistant', subtitle: 'Your learning companion.')),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF21172D), borderRadius: BorderRadius.circular(14), border: Border.all(color: violet.withOpacity(.6))),
      child: const Row(children: [
        Icon(Icons.info_outline, color: cyan, size: 20),
        SizedBox(width: 8),
        Expanded(child: Text('Demo mode: answers are sample responses, not live AI.', style: TextStyle(fontSize: 11, color: lilac))),
      ]),
    ),
    Expanded(child: ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final m = messages[i];
        final isYou = m['from'] == 'you';
        return Align(
          alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: isYou ? violet.withOpacity(.7) : panel, borderRadius: BorderRadius.circular(18)),
            child: Text(m['text'] ?? ''),
          ),
        );
      },
    )),
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(children: [
        Expanded(child: TextField(controller: input, onSubmitted: (_) => send(), decoration: InputDecoration(hintText: 'Ask about studying...', filled: true, fillColor: panel, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none)))),
        const SizedBox(width: 8),
        IconButton.filled(onPressed: send, icon: const Icon(Icons.send), style: IconButton.styleFrom(backgroundColor: violet)),
      ]),
    ),
  ]);
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const _PageHeader(title: 'Your profile', subtitle: 'Build habits that last.'),
      const SizedBox(height: 28),
      Center(child: Container(width: 92, height: 92, decoration: BoxDecoration(shape: BoxShape.circle, color: violet.withOpacity(.3), border: Border.all(color: cyan.withOpacity(.7))), child: const Icon(Icons.person, size: 48, color: cyan))),
      const SizedBox(height: 14),
      const Center(child: Text('Student', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      const Center(child: Text('Your focus journey starts here', style: TextStyle(color: lilac))),
      const SizedBox(height: 28),
      const _SettingsRow(icon: Icons.flag_outlined, title: 'Study goals', subtitle: 'Set a daily target'),
      const _SettingsRow(icon: Icons.notifications_outlined, title: 'Notifications', subtitle: 'Reminder settings'),
      const _SettingsRow(icon: Icons.palette_outlined, title: 'Appearance', subtitle: 'Futuristic dark theme'),
      const _SettingsRow(icon: Icons.privacy_tip_outlined, title: 'Privacy', subtitle: 'Your data and preferences'),
      const SizedBox(height: 18),
      const Text('FOCUS AI starter • Local demo', textAlign: TextAlign.center, style: TextStyle(color: lilac, fontSize: 11)),
    ],
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: Icon(icon, color: cyan),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: lilac, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: lilac),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This setting can be implemented in the next version.'))),
    ),
  );
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.subtitle});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
    const SizedBox(height: 7),
    Text(subtitle, style: const TextStyle(color: lilac, fontSize: 13)),
  ]);
}
