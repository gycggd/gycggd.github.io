---
title: "Leetcode Weekly Contest 80"
date: 2018-04-15T10:43:24+08:00
Categories:
    - LeetCode 
---

# 819. Most Common Word

## Description

<div class="question-content">
              <p></p><p>Given a paragraph&nbsp;and a list of banned words, return the most frequent word that is not in the list of banned words.&nbsp; It is guaranteed there is at least one word that isn't banned, and that the answer is unique.</p>

<p>Words in the list of banned words are given in lowercase, and free of punctuation.&nbsp; Words in the paragraph are not case sensitive.&nbsp; The answer is in lowercase.</p>

<pre><strong>Example:</strong>
<strong>Input:</strong> 
paragraph = "Bob hit a ball, the hit BALL flew far after it was hit."
banned = ["hit"]
<strong>Output:</strong> "ball"
<strong>Explanation:</strong> 
"hit" occurs 3 times, but it is a banned word.
"ball" occurs twice (and no other word does), so it is the most frequent non-banned word in the paragraph. 
Note that words in the paragraph are not case sensitive,
that punctuation is ignored (even if adjacent to words, such as "ball,"), 
and that "hit" isn't the answer even though it occurs more because it is banned.
</pre>

<p>&nbsp;</p>

<p><strong>Note: </strong></p>

<ul>
	<li><code>1 &lt;= paragraph.length &lt;= 1000</code>.</li>
	<li><code>1 &lt;= banned.length &lt;= 100</code>.</li>
	<li><code>1 &lt;= banned[i].length &lt;= 10</code>.</li>
	<li>The answer is unique, and written in lowercase (even if its occurrences in <code>paragraph</code>&nbsp;may have&nbsp;uppercase symbols, and even if it is a proper noun.)</li>
	<li><code>paragraph</code> only consists of letters, spaces, or the punctuation symbols <code>!?',;.</code></li>
	<li>Different words in&nbsp;<code>paragraph</code>&nbsp;are always separated by a space.</li>
	<li>There are no hyphens or hyphenated words.</li>
	<li>Words only consist of letters, never apostrophes or other punctuation symbols.</li>
</ul>

<p>&nbsp;</p>
<p></p>
</div>

## Solution

Simple String processing

```
class Solution:
    def mostCommonWord(self, para, banned):
        banned = set(banned)
        # Only preserve a-z and space
        para = ''.join([_ if 'a'<=_<='z' or _==' ' else '' for _ in para.lower()])
        words = para.split()
        dic = collections.Counter(words)
        cnt, ret = 0, None
        for word in dic:
            if word not in banned:
                if dic[word]>cnt:
                    cnt = dic[word]
                    ret = word
        return ret
```

# 817. Linked List Components

## Description

<div class="question-content">
              <p></p><p>We are given&nbsp;<code>head</code>,&nbsp;the head node of a linked list containing&nbsp;<strong>unique integer values</strong>.</p>

<p>We are also given the list&nbsp;<code>G</code>, a subset of the values in the linked list.</p>

<p>Return the number of connected components in <code>G</code>, where two values are connected if they appear consecutively in the linked list.</p>

<p><strong>Example 1:</strong></p>

<pre><strong>Input:</strong> 
head: 0-&gt;1-&gt;2-&gt;3
G = [0, 1, 3]
<strong>Output:</strong> 2
<strong>Explanation:</strong> 
0 and 1 are connected, so [0, 1] and [3] are the two connected components.
</pre>

<p><strong>Example 2:</strong></p>

<pre><strong>Input:</strong> 
head: 0-&gt;1-&gt;2-&gt;3-&gt;4
G = [0, 3, 1, 4]
<strong>Output:</strong> 2
<strong>Explanation:</strong> 
0 and 1 are connected, 3 and 4 are connected, so [0, 1] and [3, 4] are the two connected components.
</pre>

<p><strong>Note: </strong></p>

<ul>
	<li>If&nbsp;<code>N</code>&nbsp;is the&nbsp;length of the linked list given by&nbsp;<code>head</code>,&nbsp;<code>1 &lt;= N &lt;= 10000</code>.</li>
	<li>The value of each node in the linked list will be in the range<code> [0, N - 1]</code>.</li>
	<li><code>1 &lt;= G.length &lt;= 10000</code>.</li>
	<li><code>G</code> is a subset of all values in the linked list.</li>
</ul>
<p></p>
</div>	

## Solution

Just count continuous nodes

```
class Solution:
    def numComponents(self, head, G):
        G = set(G)
        node = head
        cnt = 0
        while node:
            # If match, continue until not match
            if node.val in G:
                cnt += 1
                while node.next and node.next.val in G:
                    node = node.next
            node = node.next
        return cnt
```

# 818. Race Car

## Description

<div class="question-content">
              <p></p><p>Your car starts at position 0 and speed +1 on an infinite number line.&nbsp; (Your car can go into negative positions.)</p>

<p>Your car drives automatically according to a sequence of instructions A (accelerate) and R (reverse).</p>

<p>When you get an instruction "A", your car does the following:&nbsp;<code>position += speed, speed *= 2</code>.</p>

<p>When you get an instruction "R", your car does the following: if your speed is positive then&nbsp;<code>speed = -1</code>&nbsp;, otherwise&nbsp;<code>speed = 1</code>.&nbsp; (Your position stays the same.)</p>

<p>For example, after commands "AAR", your car goes to positions 0-&gt;1-&gt;3-&gt;3, and your speed goes to 1-&gt;2-&gt;4-&gt;-1.</p>

<p>Now for some target position, say the <strong>length</strong> of the shortest sequence of instructions to get there.</p>

<pre><strong>Example 1:</strong>
<strong>Input:</strong> 
target = 3
<strong>Output:</strong> 2
<strong>Explanation:</strong> 
The shortest instruction sequence is "AA".
Your position goes from 0-&gt;1-&gt;3.
</pre>

<pre><strong>Example 2:</strong>
<strong>Input:</strong> 
target = 6
<strong>Output:</strong> 5
<strong>Explanation:</strong> 
The shortest instruction sequence is "AAARA".
Your position goes from 0-&gt;1-&gt;3-&gt;7-&gt;7-&gt;6.
</pre>

<p>&nbsp;</p>

<p><strong>Note: </strong></p>

<ul>
	<li><code>1 &lt;= target &lt;= 10000</code>.</li>
</ul>
<p></p>
</div>		

## Solution

Simple BFS, use a trick to prevent Memory Limit Exceed, only remember (position, speed) pair in visited when speed==1 or speed ==-1 (After R operation).

```
class Solution:
    def racecar(self, target):
        if target==0:
            return 0
        q = [(0, 1)]
        visited = set((0, 1))
        cnt = 0
        while q:
            new_q = []
            cnt += 1
            for pos, sp in q:
                p1, s1 = pos+sp, sp*2
                if p1==target:
                    return cnt
                p2, s2 = pos, -1 if sp>0 else 1
                
                # If we remember every position and speed pair, we get Memory Limit Exceed
                # The most annoying part is continuous R, so only remember situations with speed 1 and -1
                if (p1, s1) not in visited:
                    if s1==1 or s1==-1:
                        visited.add((p1, s1))
                    new_q.append((p1, s1))
                if (p2, s2) not in visited:
                    visited.add((p2, s2))
                    if s1==1 or s1==-1:
                        visited.add((p1, s1))
                    new_q.append((p2, s2))
            q = new_q
        return -1
```

# 816. Ambiguous Coordinates

## Description

<div class="question-content">
              <p></p><p>We had some 2-dimensional coordinates, like <code>"(1, 3)"</code> or <code>"(2, 0.5)"</code>.&nbsp; Then, we removed&nbsp;all commas, decimal points, and spaces, and ended up with the string&nbsp;<code>S</code>.&nbsp; Return a list of strings representing&nbsp;all possibilities for what our original coordinates could have been.</p>

<p>Our original representation never had extraneous zeroes, so we never started with numbers like "00", "0.0", "0.00", "1.0", "001", "00.01", or any other number that can be represented with&nbsp;less digits.&nbsp; Also, a decimal point within a number never occurs without at least one digit occuring before it, so we never started with numbers like ".1".</p>

<p>The final answer list can be returned in any order.&nbsp; Also note that all coordinates in the final answer&nbsp;have exactly one space between them (occurring after the comma.)</p>

<pre><strong>Example 1:</strong>
<strong>Input:</strong> "(123)"
<strong>Output:</strong> ["(1, 23)", "(12, 3)", "(1.2, 3)", "(1, 2.3)"]
</pre>

<pre><strong>Example 2:</strong>
<strong>Input:</strong> "(00011)"
<strong>Output:</strong> &nbsp;["(0.001, 1)", "(0, 0.011)"]
<strong>Explanation:</strong> 
0.0, 00, 0001 or 00.01 are not allowed.
</pre>

<pre><strong>Example 3:</strong>
<strong>Input:</strong> "(0123)"
<strong>Output:</strong> ["(0, 123)", "(0, 12.3)", "(0, 1.23)", "(0.1, 23)", "(0.1, 2.3)", "(0.12, 3)"]
</pre>

<pre><strong>Example 4:</strong>
<strong>Input:</strong> "(100)"
<strong>Output:</strong> [(10, 0)]
<strong>Explanation:</strong> 
1.0 is not allowed.
</pre>

<p>&nbsp;</p>

<p><strong>Note: </strong></p>

<ul>
	<li><code>4 &lt;= S.length &lt;= 12</code>.</li>
	<li><code>S[0]</code> = "(", <code>S[S.length - 1]</code> = ")", and the other elements in <code>S</code> are digits.</li>
</ul>

<p>&nbsp;</p>
<p></p>
</div>

## Solution

```
class Solution:
    def ambiguousCoordinates(self, S):
        
        def possible_val(S):
            ret = set()
            # S itself valid
            if S[0]!='0' or len(S)==1:
                ret.add(S)
            for _ in range(1, len(S)):
                left, right = S[:_], S[_:]
                # left of . valid if first char is not '0' or its length is just 1
                if len(left)==1 or not left[0]=='0':
                    # right of . valid if last char is not '0'
                    if right[-1]!='0':
                        ret.add(left+'.'+right)
            return ret
        
        # Remove parenthesis
        S = S[1:-1]
        ret = []
        for i in range(1, len(S)):
            # S1: String for first coord, S2: String for second coord
            S1, S2 = S[:i], S[i:]
            # Possible values for S1 and S2
            s1, s2 = possible_val(S1), possible_val(S2)
            if not s1 or not s2: continue
            for c1 in s1:
                for c2 in s2:
                    ret.append('('+c1+', '+c2+')')
        return ret
```
