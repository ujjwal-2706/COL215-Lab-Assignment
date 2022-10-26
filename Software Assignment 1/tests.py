from kmap import is_legal_region

tests=[[[[None,1],[0,None]],[0,None]],
[[[0,None],[None,1]],[0,0]],
[[[None,None],[1,0]],[None,0]],
[[[None,0],[None,None]],[1,1]],
[[[None,None],[0,1]],[None,1]],
[[[0,None],[0,None]],[1,1]],
[[[0,1],[0,0]],[1,0]],
[[[1,None],[1,1]],[None,1]],
[[[1,1],[None,0]],[1,1]],
[[[0,None],[1,None]],[None,0]],
[[[1,1,0,1],[1,1,None,None]],[0,0,None]],
[[[1,None,1,1],[0,1,0,0]],[None,0,0]],
[[[0,1,1,0],[1,1,0,None]],[1,None,1]],
[[[1,None,1,0],[1,0,1,0]],[0,None,0]],
[[[0,None,1,0],[0,0,None,0]],[1,0,1]],
[[[0,1,1,0],[1,None,0,1]],[None,1,0]],
[[[None,0,1,None],[None,None,0,0]],[None,None,None]],
[[[0,1,0,None],[1,1,1,0]],[None,None,0]],
[[[1,None,None,1],[0,1,None,None]],[None,0,1]],
[[[None,None,None,0],[None,None,None,None]],[1,0,None]],
[[[None,1,0,None],[None,0,0,None],[1,None,None,None],[1,1,None,0]],[0,1,0,1]],
[[[None,0,None,1],[None,0,None,0],[None,1,None,None],[1,None,1,0]],[None,1,0,None]],
[[[1,0,0,0],[0,0,None,None],[None,0,0,1],[None,0,0,1]],[1,0,0,1]],
[[[1,None,1,None],[0,1,0,None],[0,1,1,0],[1,None,None,0]],[1,0,0,1]],
[[[0,1,None,None],[1,None,0,0],[0,None,0,1],[0,0,0,1]],[0,0,1,1]],
[[[None,1,1,None],[0,1,1,0],[None,1,0,None],[0,None,0,None]],[1,None,None,None]],
[[[0,None,0,1],[None,0,0,None],[0,1,0,None],[None,1,None,None]],[1,0,0,1]],
[[[1,None,None,1],[0,1,None,0],[1,None,1,1],[0,1,None,0]],[1,None,1,0]],
[[[1,None,0,1],[None,None,None,0],[0,1,0,1],[1,None,1,1]],[None,0,None,0]],
[[[1,0,0,None],[None,0,None,None],[0,0,None,0],[None,1,0,0]],[1,None,0,1]]]

for test in tests:
  ans = is_legal_region(test[0], test[1])
  print(ans[0], ans[1], ans[2])
