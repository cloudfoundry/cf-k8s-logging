package cache

import (
	"runtime"

	"sync"

	metrics "code.cloudfoundry.org/go-metric-registry"
	sigar "github.com/cloudfoundry/gosigar"
)

// MemoryAnalyzer reports the available and total memory.
type MemoryAnalyzer struct {
	// metrics
	setAvail metrics.Gauge
	setTotal metrics.Gauge
	setHeap  metrics.Gauge

	// cache
	avail uint64
	total uint64
	heap  uint64

	sync.Mutex
}

// NewMemoryAnalyzer creates and returns a new MemoryAnalyzer.
func NewMemoryAnalyzer(m Metrics) *MemoryAnalyzer {
	return &MemoryAnalyzer{
		setAvail: m.NewGauge(
			"log_cache_available_system_memory",
			"Current system memory available.",
			metrics.WithMetricLabels(map[string]string{"unit": "bytes"}),
		),
		setHeap: m.NewGauge(
			"log_cache_heap_in_use_memory",
			"Current heap memory usage.",
			metrics.WithMetricLabels(map[string]string{"unit": "bytes"}),
		),
		setTotal: m.NewGauge(
			"log_cache_total_system_memory",
			"Total system memory.",
			metrics.WithMetricLabels(map[string]string{"unit": "bytes"}),
		),
	}
}

// Memory returns the heap memory and total system memory.
func (a *MemoryAnalyzer) Memory() (heapInUse, total uint64) {
	a.Lock()
	defer a.Unlock()

	var m sigar.Mem
	m.Get()

	a.avail = m.ActualFree
	a.total = m.Total

	a.setAvail.Set(float64(m.ActualFree))
	a.setTotal.Set(float64(m.Total))

	var rm runtime.MemStats
	runtime.ReadMemStats(&rm)

	a.heap = rm.HeapInuse
	a.setHeap.Set(float64(a.heap))

	return a.heap, a.total
}

// StaticMemoryAnalyzer reports the available and total memory.
type StaticMemoryAnalyzer struct {
	// metrics
	setTotal metrics.Gauge
	setHeap  metrics.Gauge

	// cache
	limit uint64

	sync.Mutex
}

// NewStaticMemoryAnalyzer creates and returns a new StaticMemoryAnalyzer.
func NewStaticMemoryAnalyzer(m Metrics, limit uint64) *StaticMemoryAnalyzer {
	return &StaticMemoryAnalyzer{
		setHeap: m.NewGauge(
			"log_cache_heap_in_use_memory",
			"Current heap memory usage.",
			metrics.WithMetricLabels(map[string]string{"unit": "bytes"}),
		),
		setTotal: m.NewGauge(
			"log_cache_total_system_memory",
			"Total system memory.",
			metrics.WithMetricLabels(map[string]string{"unit": "bytes"}),
		),
		limit: limit,
	}
}

// Memory returns the heap memory limit.
func (a *StaticMemoryAnalyzer) Memory() (heapInUse, total uint64) {
	a.setTotal.Set(float64(a.limit))

	var rm runtime.MemStats
	runtime.ReadMemStats(&rm)

	a.setHeap.Set(float64(rm.HeapInuse))

	return rm.HeapInuse, a.limit
}
