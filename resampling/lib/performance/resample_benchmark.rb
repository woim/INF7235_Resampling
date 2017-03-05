require 'benchmark'
require 'csv'
require_relative 'time_tracking'
require_relative '../resampling/resampler'
require_relative '../resampling'

BENCHMARKING_RESULT_FILE_PATH = './benchmark_result.csv'

File.delete(BENCHMARKING_RESULT_FILE_PATH) if File.exist?(BENCHMARKING_RESULT_FILE_PATH)

def append_csv(arr)
  CSV.open(BENCHMARKING_RESULT_FILE_PATH, "a+") do |csv|
    csv << arr
  end
end

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
IMAGES = ['monkey_small.png', 'monkey_medium.png', 'monkey_large.png']
NB_THREADS = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536]

###############################################################
# Nombre de fois ou on repete l'execution.
###############################################################
AVEC_GC = false
NB_WARMUP = 10
NB_REPETITIONS = 3
warmup = false

#####
# TRANSFORMATION
#####

ROTATION = [5,30,60]
TRANSLATION = [10,25,50]

###############################################################
# Methodes *paralleles* a 'benchmarker'.  La version sequentielle est
# toujours executee avant les versions paralleles et son temps imprime
# au debut de chaque ligne, pour permettre les mesures ulterieures
# d'acceleration.
###############################################################

METHODES = ['process_pcall', 'process_peach','process_reduced_list']

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

resampler_warmup = Resampler.create do |r|
  r.source_filename = "monkey_large.png"
  r.image_source = Image.new
  r.image_destination = Image.new
  r.transform = Transform.new(5,[10,10])
end

puts"WARM UP"
temps_moyen(NB_WARMUP) { resampler_warmup.send("process_peach") }

append_csv ["image", "rotation", "translation", "nb_thread", "seq", \
            METHODES[0], METHODES[0], METHODES[1], METHODES[1], \
            METHODES[2], METHODES[2], "process_peach_dynamic"]

IMAGES.each do |image|
  (0...3).each do |i|
    puts image.to_s + " " + [ROTATION[i],TRANSLATION[i],TRANSLATION[i]].to_s
    # On imprime les en-tetes de colonnes.
    resampler = Resampler.create do |r|
      r.source_filename = image
      r.image_source = Image.new
      r.image_destination = Image.new
      r.transform = Transform.new(ROTATION[i],[TRANSLATION[i],TRANSLATION[i]])
    end

    # On execute la version sequentielle.
    methode = "process_sequential"
    temps_seq = temps_moyen(4) { resampler.send(methode) }  
    image_expected = resampler.image_destination.data
    puts "time sequential: " + temps_seq.to_s
    
    # On mesure et on imprime le temps des diverses versions.
    NB_THREADS.each do |nb_threads|
      results = [image,ROTATION[i].to_s,TRANSLATION[i].to_s,nb_threads,temps_seq]

      # On execute les versions paralleles.
      METHODES.each do |methode|
        puts "Nb threads: " + nb_threads.to_s + " method: " + methode.to_s
        temps_par = temps_moyen(NB_REPETITIONS) { resampler.send(methode, nb_threads ) }
        results << temps_par
        results << image_expected.eql?(resampler.image_destination.data).to_s
      end

      if nb_threads > 10
        method = "process_peach_dynamic"
        temps_par = temps_moyen(NB_REPETITIONS) { resampler.send(method, nb_threads ) }
        puts "Nb threads: " + nb_threads.to_s + " method: " + method.to_s
        results << temps_par
        results << image_expected.eql?(resampler.image_destination.data).to_s
      end

      append_csv results
    end
  end
end
