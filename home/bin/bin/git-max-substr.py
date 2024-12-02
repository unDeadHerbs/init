#!/usr/bin/env python3
#!/usr/bin/env -S /bin/sh -c "exec \$(dirname \$(realpath "\$0"))/../.virtualenv/bin/python -E "\$0" "\$@""

# I know this isn't the best way to do this, it's really slow to
# search the repository.  I plan to build a better version of this off
# of either byte pair encoding or the Apriori Algorithm.

import os
import subprocess
import random
import string
import re
from tqdm import tqdm
import time
import sys

def count_sequence_in_repo(pat,exclude="^[#]",file_types=["h","c","hpp","cpp"]):
    pat = re.escape(pat)
    # TODO: escape the " symbol?, how does subprocess work?
    result = subprocess.run(
        ["git", "count--pat-exclude-types", pat,exclude] + ["*."+t for t in file_types],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True)
    if result.returncode != 0: raise RuntimeError(f"Error listing files in repository: {result.stderr}")
    return int(result.stdout.splitlines()[0])

def evolve_string_in_repo(regex, min_generations=100, pop_size=100, mutation_rate=0.1):
    """
    Returns the top strings found.  Displays some progress information.
    """
    if any(s in regex for s in '*+'):
        pattern = re.compile(regex)
    else:
        pattern = re.compile(".*"+regex+".*")

    def fitness(s):
        """This seems like a good function for now."""
        score = len(s) * max(0,count_sequence_in_repo(s)-1)
        print(f"{re.escape(s)} : {score}")
        return score

    def mutate(start_string):
        s = list(start_string)
        for i in range(len(s)):
            if random.random() < mutation_rate:
                s[i] = random.choice(string.printable[:-4])
        if random.random() < mutation_rate:
            rev = random.random() < 0.3
            if rev: s=s[::-1]
            if random.random() < 0.5 and len(s) > 1:
                s.pop(random.randint(0, len(s) - 1))
            else:
                s.append(random.choice(string.printable[:-4]))
            if rev: s=s[::-1]
        new_string = "".join(s)
        return new_string if pattern.fullmatch(new_string) else start_string
    def force_mutate(s):
        ns = mutate(s)
        while s == ns:
            ns = mutate(s)
        return ns

    def crossover(parent1, parent2):
        """Perform crossover between two parent strings."""
        split = random.randint(0, min(len(parent1), len(parent2)))
        offspring = parent1[:split] + parent2[split:]
        return offspring if pattern.fullmatch(offspring) else parent1

    population = []
    population_metrics = []
    with tqdm(total=pop_size, desc="Initial Population ") as pb:
        has_base = all(s not in regex for s in '.+*[?') and pattern.fullmatch(regex)
        if has_base:
            # the pattern is probably a keyword or identifier
            s=fitness(regex)
            if s:
                pb.update(1)
                population.append(regex)
                population_metrics.append((regex,s))
        else:
            # add some quick candidates
            # TODO: make a better list dynamically from some files?
            # Probably not, this mutation method is doomed anyway, see top comment
            for c in ["class","try","=","struct","public"]:
                if not pattern.fullmatch(c): continue
                s=fitness(c)
                if not s: continue
                pb.update(1)
                population.append(c)
                population_metrics.append((c,s))
        while len(population) < pop_size:
            candidate = "".join(random.choices(string.printable[:-4], k=random.randint(3, 6)))
            s = fitness(candidate)
            if s==0:
                # TODO: This isn't a very good generation mechanism; but, it's MUCH faster.
                candidate = force_mutate(random.choices(population))
                s = fitness(candidate)
            while s == 0:
                # Find better seeds
                candidate = force_mutate(candidate)
                if candidate not in population:
                    s = fitness(candidate)
            if pattern.fullmatch(candidate) and candidate not in population:
                pb.update(1)
                population.append(candidate)
                population_metrics.append((candidate,s))

    best_strings = []
    best_count = max(2,min(pop_size//10,int(pop_size**(.5))))

    print("Evolving strings...")

    generations=min_generations
    generation=0
    while generation<generations:
        def second(member):
            return member[1]
        population_metrics = sorted(population_metrics, key=second, reverse=True)

        if generation!=0:
            last_best = best_strings[:2]
        best_strings = population_metrics[:best_count]
        #progress_bar.write(f"Generation {generation + 1}/{generations}:",best_strings[:5])
        generation_percent = int((1000.0*generation)/generations)/10.0
        print(f"Generation {generation + 1}/{generations} {generation_percent}%:",best_strings[:5])
        if generation!=0:
            if last_best != best_strings[:2]:
                print(f"Improvement, granting another generation")
                generations+=1

        mating_pool = [m for m,s in population_metrics[:pop_size//2]]
        
        next_metrics = best_strings[:]
        next_generation = [m for m,s in next_metrics]
        while len(next_generation) < pop_size:
            parent1, parent2 = random.sample(mating_pool, 2)
            offspring = crossover(parent1, parent2)
            offspring = mutate(offspring)
            s=fitness(offspring)
            if offspring not in next_generation and s:
                next_generation.append(offspring)
                next_metrics.append((offspring,s))
                
        population = next_generation
        population_metrics = next_metrics
        generation+=1
    return best_strings

if __name__ == "__main__":
    regex = r".*" # TODO: make this an argument that defaults to ".*"
    print("Evolving strings in the repository...")
    top_strings = evolve_string_in_repo(regex, min_generations=100, pop_size=100, mutation_rate=0.2)
    print("\nFinal Top Strings:")
    for i, s in enumerate(top_strings, 1):
        print(f"{i}. '{s}'")
