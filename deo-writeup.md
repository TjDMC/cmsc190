# Paper Overview
Solving complex optimization problems has been a hot topic the past decade and has garnered large followings most of which are practitioners and researchers. This attention has brought upon the development of new metaheuristic algorithms, many of which are inspired by various phenomena demonstrated by nature.
The paper proposes a new population based algorithm, the Lion Optimization Algorithm (LOA). The distinct lifestyle of lions and their characteristics of utilizing cooperation was made as the motivational basis for the development of this optimization algorithm. The algorithm is also tested against benchmark problems sourced from literature and whose primary solutions was compared with the results of the test. The results also confirm the performance of this algorithm alongside other algorithms used in the paper.

# Introduction / Optimization
Basically, optimization is searching for the best solutions out of all possible solutions. A best solution can be defined regarding either the most of some measure of success (e.g. revenue) or the least of another measure (e.g. cost) (Laguna, 2004). We can be looking at a group of answers or one answer from a set. In solving optimization problems, one's goal is to minimize or maximize a result variable of a function by trying out different parameters for input.

# Introduction / Optimization Algorithms
Optimization algorithms can be divided into two major categories, as exact and approximate (Desale, et al. 2015). Exact algorithms guarantee that the optimal solution to the problem will be found in a finite amount of time. There are, however, harder optimization problems that requires the searching of very large solution sets and thus making it impractical to use exact algorithms. As such, the usage of approximate algorithms are necessitated. These algorithms do not guarantee that the optimal solution will be found, but it can find an approximate (sometimes exact) solution to the problem in a relatively short amount of time, sometimes using a less computationally intensive method. Approximate algorithms can be further divided into two major categories as heuristic and metaheuristic algorithms (Desale, et al. 2015).

Heuristic algorithms are problem-dependent techniques that approximate the solution to a problem using readily available information. Meaning, they try to take advantage of the particularities of the problem to find a solution. Applications of these algorithms include finding the best move in a chess game, solving a tic-tac-toe puzzle, and pathfinding. In these examples, the underlying concepts of the problem are first analyzed and then used to guide the algorithm in searching for a solution. Heuristic algorithms are often greedy which generally gets them trapped in a local optimum. As a result, they usually fail to obtain the global optimum solution.

Metaheuristic algorithms, on the other hand, requires minimal or no assumptions about the problem being solved. This makes them applicable to a wide variety of problems. A metaheuristic algorithm optimizes a problem by iteratively improving a candidate solution until a desired quality is achieved. In contrast to heuristic algorithms, metaheuristic algorithms often employ mechanisms to escape from being stuck in a local optimum and thus making them more likely to obtain the global optimum solution. An example of such mechanisms is the deliberate deterioration of a solution in order to more thoroughly explore the solution space in hopes of finding a better solution.

For centuries humans have relied on nature to find the most appropriate solutions to problems. That's why in the past decades, computer scientists has turned to nature to develop novel algorithms.

# Examples of Meta-heuristic algorithms: Genetic algorithm
The genetic algorithm (Holland, 1975) is modeled after Darwin’s theory of evolution. An initial population is initialized in which each individual represents a solution to the problem. Through a series of selection, crossover, and mutation, successive populations are generated until an individual with a desired fitness is obtained. Fitness is defined as how well an individual can solve the given problem.
Selection pertains to the process in which individuals with the best fitness are selected and allowed to pass their genes (or properties. E.g. bits) to the next generation. The individuals with the highest fitness have a higher chance of being selected.
Crossover is when genes of the selected individuals are interchanged with each other. The results are called offspring and are added to the next generation.
Mutation refers to when genes of the offspring are subject to mutate or change (e.g. Binary value from 1 to 0). This further diversifies the sample space and consequently prevents the algorithm from converging early.

#Examples of Meta-heuristic algorithms: Particle Swarm Optimization
The Particle Swarm Optimization (Eberhart,1995) algorithm is modeled after the movement of a swarm as a whole (e.g. A flock
of birds collectively foraging for food). In this algorithm, an initial set of particles is first initialized with each
particle having a random initial velocity. These particles are then flung through hyperspace where each of their position
represents a solution to the problem at hand. Each of these solutions are evaluated regarding their fitness and a particle's
current most fit solution is stored as its 'pbest'. The current best solution attained by the entire set particles is also stored; this is called 'gbest'. For each time step of the algorithm, each particle is accelerated towards its 'pbest' and the 'gbest'. Eventually, these particles will converge around an optimal solution.

# Artificial Immune Systems
Artificial immune systems are a classification of rule based machine learning systems inspired by the vertebrate immune systems. This systems model the learning and memory for use in problem solving. These systems adapt to what they learn in the environment to become better at solving problems. Compared to GA these methods use less mutation per generation whenever the fitness becomes better.

# Ant Colony Optimization
Ants can find food faster by utilizing shorter paths found by the other ants in its colony. An ant would leave more pheromones when it has reached the food faster so other ants would be more inclined to use the path. This also applies to optimization by using memory and prioritizing directions with more incentives.

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

# Inspiration

They're socially inclined meaning that they also organize information that other lions have collected and use them for their benefit.
Male lions have radically different social behavior and appearance than the female lions and v.v.
The lions can also be classified if they're residents or nomads. Resident lions create groups called prides, establish their territories and flourish there while nomads take what they need in an area then finds another area to pillage not establishing territories.
A pride typically would include five females have cubs of both sexes and one or more adult male lions.
As young males would grow they would separate from their birth pride and establish their own prides.
Nomads, who doesn't establish territories, would move about sporadically (whenever they want) and either in pairs or singularly.
Lions usually hunt together in prides. Female lions would work together to surround and swiftly catch the prey. There could also be a hunter female lion who would go out of territory to hunt on their own while the other members of the pride would wait for the lioness to return. But still, coordinated group hunting would bring greater success in prey hunts.
Lions do go mate anytime around the year and females can have more than one reproductive cycle each year. A lioness can also mate with more than one lion when in heat.
Additionally, to mark their territory the pride would place urine all over the place to drive away others who would intrude.

# Idea
The initially proposed algorithm started an initial population formed by a set of solutions randomly generated labelled as Lions. A percentage `%N` of the initial population of solutions are selected as 'Nomad Lions' while the rest are the 'Resident Lions.' While the nomad lions are individually grouped, the resident lions are then further divided into partitions called 'Prides' where a percentage `%S` is percentage of the females in the group but in nomad lions, this percentage is reversed, where `%S` will be used to identify the males in the nomad lions.
Each lion will have a variable pertaining to the best obtained solution for every passing iteration that will be called best visited position and will be updated regularly for every iteration. In each pride, a few random females will be selected to go hunting. These females will encircle the prey and catch it. The males in the pride will roam the territory. The females may mate with one or more resident males then a young male is created. These males may establish their own prides and territory later or may become a nomad.
The nomad lions roams around the search space to find better (places) solutions. A nomad lion may invade and replace a resident male in a pride, driving out that resident male. Also, a female lion may also migrate to another pride or become a nomad herself. Weak lions, who have not found better prey (solutions) where there is no competition, will die or be killed. The process will go on until the stopping condition is satisfied.

# Proposed Algorithm
The first step of the algorithm is to randomly generate solutions called Lions with a population of N. In a Nvar dimensional search space optimization problem a Lion is represented as
```
Lion = [x_1, x_2,..., x_Nvar]
```
As most optimization algorithms, there will be a given cost function, where the fitness value of a solution can be gauged.
```
fitness = f(Lion) = f(x_1, x_2,..., x_Nvar)
```
Along with generating the solutions, a percentage of N will be selected as nomad lions and the rest would be divided into a number P of prides. The solutions in the pride will have a specific gender which will identify their role in finding solutions. A percentage S of the prides in the population are labeled as females (others are males) while in nomads will have the ratio reversed where 1-S will be the percentage of females in the nomads. The percentage S is typically chosen between 75 to 90 percent.



# Meta-heuristic algorithms used for comparison: Invasive Weed Optimization
# Meta-heuristic algorithms used for comparison: Biogeography-Based Optimization
# Meta-heuristic algorithms used for comparison: Gravitational Search Algorithm
# Meta-heuristic algorithms used for comparison: Hunting Search
# Meta-heuristic algorithms used for comparison: Bat Algorithm
# Meta-heuristic algorithms used for comparison: Water Wave Optimization
