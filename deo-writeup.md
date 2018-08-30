# Introduction / What is Optimization?
Basically, optimization is searching for the best solutions out of all possible solutions. We can be looking at a group of answers or one answer from a set. In solving optimization problems, one's goal is to minimize or maximize a result variable of a function by trying out different parameters for input.

# Introduction
Optimization problems have many applications and complexities of problems in optimization varies from an application to another. An optimization problem gets harder when it considers bigger and bigger sets of possible solutions thus increasing the searching time for any algorithm that would try to solve these kinds of problems.

# Introduction / Metaheuristic optimization algorithms
Metaheuristic algorithms are algorithms that would initially sample a set of solutions from the set, uses the solutions to test if they are acceptable enough or else alter the solutions a little to find better ones. Although meta-heuristic algorithms does not need that much information as other optimization algorithms, meta-heuristic does not guarantee the very best solution in the set of solutions but only in a subset of the set of solutions.
For centuries we have relied on nature to show us the most appropriate solutions to problems. That's why in the last decades computer scientists has turned to nature to develop novel algorithms.

# Genetic algorithms

# Artificial Immune Systems
Artificial immune systems are a classification of rule based machine learning systems inspired by the vertebrate immune systems. This systems model the learning and memory for use in problem solving. These systems adapt to what they learn in the environment to become better at solving problems. Compared to GA these methods use less mutation per generation whenever the fitness becomes better.

# Ant Colony Optimization
Ant colonies can find food faster by utilizing shorter paths found by the ants in its colony. An ant would leave more pheromones when it has reached the food faster so other ants would be more inclined to use the path. This also applies to optimization by using memory and prioritizing directions with more incentives.

# Marriage in Honey Bee Optimization
The model simulates the evolution of honey-bees starting with a solitary colony (single queen without a family) to the emergence of an eusocial colony (one or more queens with a family).

# Applications
Researchers have made good use of optimization problems such as scheduling problems, data clustering, image and video processing, tuning of neural networks, and pattern recognition

# Scheduling problems
Scheduling problems are problems where different difficulty on jobs would take different amount of time that will be processed by different nodes. The problem is to minimize the time that all the nodes would simultaneously get to be finished. Optimization helps find the best job to node assignment to minimize the mean time.

# Data clustering
Data clustering or cluster analysis is the way to group a set of objects such that objects with the most similarity a group together in clusters. The objects may have one or more properties to identify and the groups may have smaller subgroups that one can also classify. Optimization helps identify the best clustering of an object based on its parameters.

# Image and video processing


# Tuning of neural networks
Neural networks can be tuned by its parameters. These parameters talked about are parameters that are constant throughout the run of the network. This parameters may be tuned to get the best performance out of neural network which may also drive the network to learn faster, slower or not at all. Optimization helps to find the best parameters that will drive the system's performance.

# Pattern recognition
Patterns can be also found in data. These patterns can help add to the metadata of that data. Pattern recognition finds those patterns that can be found off the data. Optimization helps identify patterns that best identify a given data.

# Inspiration for the algorithm
Lions have displayed cooperation and antagonism especially in hunting.

# Lion Pride Optimizer
Previous works such as the Lion Pride Optimizer was inspired by this brutal competition of males whom also plays an important role for the persistence of the pride. In the work, the optimization chooses two of the best points in a "pride" and each "female" with a mating coefficient will create 4 offsprings only to choose one at last based on a male in the pride. The mating coefficient is treated as a randomized coefficient to further enhance the randomicity of the algorithm. The coefficient is calculated as `mc0 (rand(1,1) - 0.5)` where `mc0` is the base mating coefficient. The optimization bases its offspring generation with the equations
```
x^(k+1)_(4i-3) = X^k_(b1)+mc^k_i(X^k_(b1)-X^k_i)
x^(k+1)_(4i-2) = X^k_(b1)-mc^k_i(X^k_(b1)-X^k_i)
x^(k+1)_(4i-1) = X^k_(b2)+mc^k_i(X^k_(b2)-X^k_i)
x^(k+1)_(4i) = X^k_(b2)-mc^k_i(X^k_(b2)-X^k_i)
```
where `i` is the pride number `k` is the generation and `X^k_i` is the female. The optimization also uses safeguards to prevent stagnation in the pride by either replacing all members in the pride or resetting the search space when it meets a certain threshold


They're socially inclined meaning that they also organize information that other lions have collected and use them for their benefit.
Male lions have radically different social behavior and appearance than the female lions and v.v.
The lions can also be classified if they're residents or nomads. Resident lions create groups called prides, establish their territories and flourish there while nomads take what they need in an area then finds another area to pillage not establishing territories.
A pride typically would include five females have cubs of both sexes and one or more adult male lions.
As young males would grow they would separate from their birth pride and establish their own prides.
Nomads, who doesn't establish territories, would move about sporadically (whenever they want) and either in pairs or singularly.
Lions usually hunt together in prides. Female lions would work together to surround and swiftly catch the prey. There could also be a hunter female lion who would go out of territory to hunt on their own while the other members of the pride would wait for the lioness to return. But still, coordinated group hunting would bring greater success in prey hunts.
Lions do go mate anytime around the year and females can have more than one reproductive cycle each year. A lioness can also mate with more than one lion when in heat.
Additionally, to mark their territory the pride would urinate all over the place to drive away others who would intrude.
