---
title: 遗传算法(Genetic Algorithm)是怎么一回事
date: 2017-09-09 23:02:41
tags: 
    - MachineLearning
    - Algorithms
---

# 开始

今天在课上Prof Lin讲到了遗传算法，于是了解了一下这个算法是怎么一回事，确实非常“遗传”。

# 生物上的遗传与进化

> It is not the strongest of the species that survive, but the one most responsive to change. 
-Charles Darwin

达尔文所说的这句“物竞天择，适者生存”，指的是一个种群的基因会经过环境的挑选，使得带有某些基因的个体能够更加适应环境从而存活下来，同时也提纯了这种基因，因为能够存活下来个体大多带有利于在环境中生存的基因。

遗传算法就是基于这种思想，来一个种群中通过进化来找出我们想要的某个特定的算法。

# 遗传算法

从第一代`Generation0`开始，根据每个体的`fitness`，一步步地演化，最终便得到符合我们要求的算法个体。

## 如何演化

在种群的演化过程中，有如下两个要素：

1. 如何繁殖，如何产生下一代的个体
2. 如何筛选，即物竞天择，用什么样的方式挑选出适应性(Fitness)最好的个体作为下一代

### 演化方式 

演化有以下几种方式：

* `copy`: 照搬上一个`Generation`中的部分个体
* `crossover`: 交叉上一个`Generation`中的多个个体，形成新的个体
* `mutate`: 对上一个`Generation`中的个体进行变异，形成新的个体

### 适应性 

对于`Fitness`需要给出一个`Fitness Function`用来评判当前的个体在多大程度上满足我们的要求，例如：一个决策树分类算法能够对训练集中的多少输入给出正确的输出。

然后根据`Fitness Function`提出一个`filterFitness`的方法来根据`fitness`筛选掉一批个体

### 结合 

根据上面的演化方式可以产生很多的个体，然后通过`Fitness Function`可以淘汰掉一部分糟糕的个体，从而产生`Next Generation`。

用公式来表示的话就是：

```
G[i+1] = filterFitness(        # Filter individual with poor fitness
            copy(A%, G[i]) ∪   # Copy individuals from previous generation
            crossover(B%, G[i]) ∪  # Crossover individuals from previous generation
            mutate(C%, G[i])   # Mutate individuals from previous generation
         )
```

## 完整算法

```
def function fitness;
def function filterFitness;

G = [Init first ]

do:
    G = filterFitness(        
            copy(A%, G) ∪  
            crossover(B%, G) ∪ 
            mutate(C%, G)  
        )
until fitness(G)>Required Value;
```

## 算法的效率

上面演化的过程中我们有三个常数 `A, B, C`分别是复制的比例，杂交的比例和变异的比例，它们会影响算法得到最终结果的效率。

还有`filterFitness`中对于产生的个体的淘汰的方式，也会影响算法的效率。

# 例子

## 题目

```
用遗传算法求出f(x)的最大值，其中f(x) = x + 10sin(5x) + 7cos(4x), x∈[0,9]
-from zhihu.com
```

## 代码

``` python
# coding=utf-8
from __future__ import print_function
import random
import math


def generate_random(length):
    return random.randint(0, 2 ** length)


def print_bit(n, length):
    for i in range(length):
        if (n & (1 << i)) != 0:
            print(1, end="")
        else:
            print(0, end="")
    print("")


# f(x) = x + 10sin(5x) + 7cos(4x), x∈[0,9]
def fitness(x):
    x = float(x)
    return x + 10 * math.sin(5 * x) + 7 * math.cos(4 * x)


def decode(x):
    return float(x) * 9 / (2 ** 17 - 1)


def crossover(a, b, length):
    cross_len = random.randint(1, length - 1)
    cross_start = random.randint(0, length - cross_len)
    mask1 = 2 ** (length + 1) - 1
    mask2 = 0
    for i in range(cross_len + 1):
        mask1 = mask1 ^ (1 << (cross_start + i))

    for i in range(cross_len + 1):
        mask2 = mask2 | (1 << (cross_start + i))

    return (a & mask1) | (b & mask2)


if __name__ == "__main__":
    g = []
    for i in range(100):
        g.append(generate_random(17))

    while True:
        new_g = []
        while len(new_g) < 200:
            individual = g[random.randint(0, len(g) - 1)]
            ran_int = random.randint(1, 200)
            if ran_int <= 20:
                new_g.append(individual)
            elif ran_int <= 140:
                new_g.append(crossover(individual, g[random.randint(0, len(g) - 1)], 17))
            elif ran_int == 200:
                new_g.append(generate_random(17))

        fitness_value = [(i, decode(i), fitness(decode(i))) for i in new_g]

        fitness_value = sorted(fitness_value, cmp=lambda a, b: int(a[2] * 10000 - b[2] * 10000), reverse=True)
        print(reduce(lambda x, y: x + y, [a[2] for a in fitness_value]) / len(fitness_value))
        g = [x[0] for x in fitness_value[:100]]
```