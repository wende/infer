test:
	swipl -g "run_tests" -f "test.pl" -t halt

cover:
	swipl -g "show_coverage(run_tests, [main])" -f "test.pl" -t halt