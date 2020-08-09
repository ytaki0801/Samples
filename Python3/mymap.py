def mymap(op, r, l1, l2): r if not l1 or not l2 else mymap(op, r + op(l1[0], l2[0]), l1[1:], l2[1:])
