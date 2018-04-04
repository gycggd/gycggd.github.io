---
title: "LeetCode 126: Word Ladder II"
date: 2018-03-17T19:30:00+08:00
tags:
    - BFS
categories:
    - Leetcode
---

[Leetcode 127. Word Ladder](https://leetcode.com/problems/word-ladder/) and [Leetcode 126. Word Ladder II](https://leetcode.com/problems/word-ladder-ii) are Breadth-First Search problems of strings.

![Description](/images/leetcode/126_2.png)

At each step, we can change one letter of a given string into another letter, but the step is valid only when the new string is in the given list `wordList`.

# Simpliest BFS (TLE)

My first solution starts BFS at the *beginWord*, at each step, check every word in the list, if it only got only one position different, add it to next level. It gots TLE.

Here is the code I used to expand each level:

```
def adj(w1, w2):
    if len(w1)!=len(w2):
        return False
    diff = 0
    for i in range(len(w1)):
        if w1[i]!=w2[i]:
            diff += 1
            if diff>=2:
                return False
    return diff==1

def expand(words, visited):
    ret = set()
    for w1 in words:
        for w2 in wordList:
            if w2 in visited:
                continue
            if adj(w1, w2):
                ret.add(w2)
    return ret
```

and the bfs code:

```
s = {beginWord}
visited = {beginWord}

while s:
    s = expand(s, visited)
    visited |= s
    if not s:
    	return []
	if endWord in s:
		break    
```

# Two-way BFS (TLE)

![1-way and 2-way bfs](/images/leetcode/126_1.png)

Since simple BFS expands more nodes than two-way BFS, I tried two-way BFS but still got TLE, here is the two-way bfs code:

```
s1, s2 = {beginWord}, {endWord}
visited1, visited2 = {beginWord}, {endWord}
path1, path2 = collections.defaultdict(list), collections.defaultdict(list)

while s1 and s2:
    s1 = expand(s1, visited1, path1)
    visited1 |= s1
    
    if s1&s2:
        return build(s1&s2, path1, path2)
    
    s2 = expand(s2, visited2, path2)
    visited2 |= s2
    
    if s1&s2:
            return build(s1&s2, path1, path2)
```

# Use wildcard to quickly match adjacent words

After TLE using two-way BFS, I realized it's the expand part that costs too much time checking words. So we need a faster way to get valid jumps between words. 

We create a map, the key of the map are words with a wildcard '\*' in it. The value is a list consists of all words that match the key. For each word, we can replace each character of it into a wildcard '\*' and put it in the list. When we want to expand from this word, we generate words with a '\*' and union all values of them.

Take `['dog', 'log', 'dot']` for example, we can get `'\*og', 'd\*g', 'do\*'` from 'dog', part of the map (used when expand 'dog') is `{'\*og':[dog, log], 'd\*g':[dog], 'do\*':[dog, dot]}`.

So the expand part becomes:

```
dic = collections.defaultdict(list)

for w in wordList:
    for i in range(len(w)):
        dic[w[:i]+'*'+w[i+1:]].append(w)

def expand(words, visited, path):
    ret = set()
    for w1 in words:
        for i in range(len(w1)):
            w = w1[:i]+'*'+w1[i+1:]
            nexts = [_ for _ in dic[w] if _ not in visited]
            ret.update(nexts)
            for n in nexts:
                path[n].append(w1)
    return ret
```

The whole solution:

```
    def findLadders(self, beginWord, endWord, wordList):
        """
        :type beginWord: str
        :type endWord: str
        :type wordList: List[str]
        :rtype: List[List[str]]
        """
        
        if endWord not in wordList:
            return []
        
        dic = collections.defaultdict(list)
        
        for w in wordList:
            for i in range(len(w)):
                dic[w[:i]+'*'+w[i+1:]].append(w)
        
        def expand(words, visited, path):
            ret = set()
            for w1 in words:
                for i in range(len(w1)):
                    w = w1[:i]+'*'+w1[i+1:]
                    nexts = [_ for _ in dic[w] if _ not in visited]
                    ret.update(nexts)
                    for n in nexts:
                        path[n].append(w1)
            return ret
        
        def havecommon(s1, s2):
            return s1&s2
            
        s1, s2 = {beginWord}, {endWord}
        visited1, visited2 = {beginWord}, {endWord}
        path1, path2 = collections.defaultdict(list), collections.defaultdict(list)
        
        if s1&s2:
            return [[beginWord, endWord]]
        
        def build(s, path1, path2):
            ret = []
            for w in s:
                ps = [[w]]
                while True:
                    new_ps = []
                    found = False
                    for p in ps:
                        if p[0] in path1:
                            found = True
                            for ww in path1[p[0]]:
                                new_ps.append([ww]+p)
                    if not found:
                        break
                    ps = new_ps
                    
                while True:
                    new_ps = []
                    found = False
                    for p in ps:
                        if p[-1] in path2:
                            found = True
                            for ww in path2[p[-1]]:
                                new_ps.append(p+[ww])
                    if not found:
                        break
                    ps = new_ps

                ret.extend(ps)
            return ret
        
        c1, c2 = 0, 1
        while s1 and s2:
            s1 = expand(s1, visited1, path1)
            visited1 |= s1
            c1 += 1
            
            if s1&s2:
                return build(s1&s2, path1, path2)
            
            s2 = expand(s2, visited2, path2)
            visited2 |= s2
            c2 += 1
            
            if s1&s2:
                return build(s1&s2, path1, path2)
            
        return []
```

Got pass in 152ms. (For word ladder, we don't need to build the path, just return $c1+c2$)