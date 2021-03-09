class owHero:
	def __init__(self, index, name):
		self.index = index
		self.name = name

class owwsHero:
	def __init__(self):
		self.dict = {
			'Reaper': owHero(0, 'Reaper'),
			'Tracer': owHero(1, 'Tracer'),
			'Mercy': owHero(2, 'Mercy'),
			'Hanzo': owHero(3, 'Hanzo'),
			'Torbjörn': owHero(4, 'Torbjörn'),
			'Reinhardt': owHero(5, 'Reinhardt'),
			'Pharah': owHero(6, 'Pharah'),
			'Winston': owHero(7, 'Winston'),
			'Widowmaker': owHero(8, 'Widowmaker'),
			'Bastion': owHero(9, 'Bastion'),
			'Symmetra': owHero(10, 'Symmetra'),
			'Zenyatta': owHero(11, 'Zenyatta'),
			'Genji': owHero(12, 'Genji'),
			'Roadhog': owHero(13, 'Roadhog'),
			'McCree': owHero(14, 'McCree'),
			'Junkrat': owHero(15, 'Junkrat'),
			'Zarya': owHero(16, 'Zarya'),
			'Soldier: 76': owHero(17, 'Soldier: 76'),
			'Lúcio': owHero(18, 'Lúcio'),
			'D.Va': owHero(19, 'D.Va'),
			'Mei': owHero(20, 'Mei'),
			'Sombra': owHero(21, 'Sombra'),
			'Doomfist': owHero(22, 'Doomfist'),
			'Ana': owHero(23, 'Ana'),
			'Orisa': owHero(24, 'Orisa'),
			'Brigitte': owHero(25, 'Brigitte'),
			'Moira': owHero(26, 'Moira'),
			'Wrecking Ball': owHero(27, 'Wrecking Ball'),
			'Ashe': owHero(28, 'Ashe'),
			'Echo': owHero(29, 'Echo'),
			'Baptiste': owHero(30, 'Baptiste'),
			'Sigma': owHero(31, 'Sigma'),
		}

	def workshopString(self, query):
		if query in self.dict:
			return 'Hero('+self.dict[query].name+')'
		else:
			return None

if __name__ == "__main__":
	a = owwsHero
	print(a.workshopString('Reaper'))
