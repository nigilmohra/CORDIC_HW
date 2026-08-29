# ===============================================================
# Makefile for 32-bit Precision CORDIC Accelerator 
# ===============================================================
# Author : Nigil M R

VERILATOR = verilator
VFLAGS    = --binary --timing -Wno-fatal --top-module CORDIC32b_tb
SRC       = CORDIC32b.v CORDIC32b_tb.v
LOGDIR    = logs
CONFIGS   = CORDIC32b
 
.PHONY: all $(CONFIGS) summary clean
 
all: $(CONFIGS) summary
 
$(CONFIGS):
	@mkdir -p $(LOGDIR)
	@echo "=== Running $@ ==="
	@mkdir -p build_$@
	$(VERILATOR) $(VFLAGS) \
	    --Mdir build_$@ -o V$@ $(SRC)
	./build_$@/V$@ | tee $(LOGDIR)/log_$@.txt
 
summary:
	@echo ""
	@echo "================ TEST SUMMARY ================"
	@for cfg in $(CONFIGS); do \
	    log=$(LOGDIR)/log_$$cfg.txt; \
	    if [ ! -f $$log ]; then \
	        echo "$$cfg : NOT RUN"; \
	        continue; \
	    fi; \
	    if grep -q "TimeOut" $$log; then \
	        echo "$$cfg : TIMEOUT"; \
	    else \
	        result=$$(grep -E "TOTAL PASS:" $$log); \
	        passed=$$(echo "$$result" | grep -oE "[0-9]+/[0-9]+" | cut -d/ -f1); \
	        total=$$(echo "$$result" | grep -oE "[0-9]+/[0-9]+" | cut -d/ -f2); \
	        if [ "$$passed" = "$$total" ] && [ -n "$$passed" ]; then \
	            echo "$$cfg : PASS ($$result)"; \
	        else \
	            echo "$$cfg : FAIL ($$result)"; \
	        fi; \
	    fi; \
	done
	@echo "==============================================="
 
clean:
	rm -rf build_* $(LOGDIR)