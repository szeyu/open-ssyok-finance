enum ProjectionMode { nominal, real }

enum MilestoneType { goalReached, debtPaidOff }

class Milestone {
  final String label;
  final MilestoneType type;

  const Milestone({required this.label, required this.type});
}

class ProjectionYear {
  final int year;
  final int calendarYear;
  final int age;
  final double totalAssets;
  final double totalDebts;
  final double nominalNetWorth;
  final double realNetWorth;
  final List<Milestone> milestones;

  const ProjectionYear({
    required this.year,
    required this.calendarYear,
    required this.age,
    required this.totalAssets,
    required this.totalDebts,
    required this.nominalNetWorth,
    required this.realNetWorth,
    this.milestones = const [],
  });
}
