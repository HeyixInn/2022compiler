
;; Function main (main, funcdef_no=0, decl_uid=2313, cgraph_uid=1, symbol_order=0)

main ()
{
  int n;
  int t;
  int i;
  int b;
  int a;
  int D.2324;

  a = 0;
  b = 1;
  i = 1;
  scanf ("%d", &n);
  printf ("%d", a);
  printf ("%d", b);
  goto <D.2321>;
  <D.2320>:
  t = b;
  b = a + b;
  printf ("%d", b);
  a = t;
  i = i + 1;
  <D.2321>:
  n.0_1 = n;
  if (i < n.0_1) goto <D.2320>; else goto <D.2322>;
  <D.2322>:
  n = {CLOBBER};
  D.2324 = 0;
  goto <D.2325>;
  <D.2325>:
  return D.2324;
}


