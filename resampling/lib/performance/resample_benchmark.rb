require 'benchmark'
require_relative 'time_tracking'
require_relative '../resampling/resampler'
require_relative '../resampling'

filename='./benchmark_result.csv'
File.open(filename)
FILE_HANDLE = File.open(filename, 'w')

def print_file(string)
  print string
  FILE_HANDLE.write(string)
end

#
# Programme pour mesurer les performances des diverses versions du
# calcul du nombre d'inversions dans un tableau.
#
# Les parametres sont specifies par l'intermediaire de variables
# d'environnement, et sont evidemment optionnels:
#
# - METHODES [methode [,methode]*] Methodes a executer
# - NB_THREADS [Fixnum] Nombre de threads a utiliser
# - TAILLE [Fixnum] Taille du tableau a generer et traiter
#
IMAGES = ['image_small.png', 'image_medium.png', 'image_large.png']
NB_THREADS = [8]

###############################################################
# Nombre de fois ou on repete l'execution.
###############################################################
AVEC_GC=false
NB_WARMUP = 10
NB_REPETITIONS = 2


#####
# TRANSFORMATION
#####

ROTATION = 5
TRANSLATION = [20, 10]

###############################################################
# Methodes *paralleles* a 'benchmarker'.  La version sequentielle est
# toujours executee avant les versions paralleles et son temps imprime
# au debut de chaque ligne, pour permettre les mesures ulterieures
# d'acceleration.
###############################################################

METHODES = ['process_pcall', 'process_peach']

###############################################################
# Execution repetitive pour calcul de temps moyen.
###############################################################

def temps_moyen( nb_fois, &block )
  return 0.0 if nb_fois == 0

  tot = 0
  nb_fois.times do
    tot += (Benchmark.measure &block).real
  end
  tot / nb_fois
end

###############################################################
# Les benchmarks.
###############################################################

# On imprime l'information sur les parametres d'execution
puts "# NB_WARMPUP = #{NB_WARMUP}"
puts "# NB_REPETITIONS = #{NB_REPETITIONS}"
puts "# AVEC_GC = #{AVEC_GC}"

# On imprime les en-tetes de colonnes.
largeur = (METHODES.map(&:size).max || 4)+ 3

["nb.th.", "seq", *METHODES].each do |x|
  print_file "#{x},"
end
print_file '\r\n'

resampler = Resampler.create do |r|
  r.source_filename = './image_small.png'
  r.image_source = Image.new
  r.image_destination = Image.new
  r.transform = Transform.new(ROTATION,TRANSLATION)
end


# On mesure et on imprime le temps des diverses versions.
NB_THREADS.each do |nb_threads|
  print_file "#{nb_threads},"

  methode = "process_sequential"

  # On execute la version sequentielle.
  temps_seq = temps_moyen(NB_REPETITIONS) { resampler.send(methode ) }
  print_file "#{temps_seq},"

  # On execute les versions paralleles.
  METHODES.each do |methode|

    temps_par = temps_moyen(NB_REPETITIONS) { resampler.send(methode, nb_threads ) }
    print "#{temps_par},"

  end
  print_file '\r\n'
end

FILE_HANDLE.close()
