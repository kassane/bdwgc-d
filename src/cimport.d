// D import file generated from 'src/gc.c'

/// See: https://issues.dlang.org/show_bug.cgi?id=23812
module cimport;

@nogc nothrow:
extern (C)
{
	alias GC_PTR = void*;
	alias GC_word = ulong;
	alias GC_signed_word = long;
	extern uint GC_get_version();
	extern __gshared ulong GC_gc_no;
	extern ulong GC_get_gc_no();
	extern int GC_get_parallel();
	extern void GC_set_markers_count(uint);
	alias GC_oom_func = void* function(ulong);
	extern __gshared void* function(ulong) GC_oom_fn;
	extern void GC_set_oom_fn(void* function(ulong));
	extern void* function(ulong) GC_get_oom_fn();
	alias GC_on_heap_resize_proc = void function(ulong);
	extern __gshared void function(ulong) GC_on_heap_resize;
	extern void GC_set_on_heap_resize(void function(ulong));
	extern void function(ulong) GC_get_on_heap_resize();
	enum GC_EventType
	{
		GC_EVENT_START,
		GC_EVENT_MARK_START,
		GC_EVENT_MARK_END,
		GC_EVENT_RECLAIM_START,
		GC_EVENT_RECLAIM_END,
		GC_EVENT_END,
		GC_EVENT_PRE_STOP_WORLD,
		GC_EVENT_POST_STOP_WORLD,
		GC_EVENT_PRE_START_WORLD,
		GC_EVENT_POST_START_WORLD,
		GC_EVENT_THREAD_SUSPENDED,
		GC_EVENT_THREAD_UNSUSPENDED,
	}
	alias GC_EVENT_START = GC_EventType.GC_EVENT_START;
	alias GC_EVENT_MARK_START = GC_EventType.GC_EVENT_MARK_START;
	alias GC_EVENT_MARK_END = GC_EventType.GC_EVENT_MARK_END;
	alias GC_EVENT_RECLAIM_START = GC_EventType.GC_EVENT_RECLAIM_START;
	alias GC_EVENT_RECLAIM_END = GC_EventType.GC_EVENT_RECLAIM_END;
	alias GC_EVENT_END = GC_EventType.GC_EVENT_END;
	alias GC_EVENT_PRE_STOP_WORLD = GC_EventType.GC_EVENT_PRE_STOP_WORLD;
	alias GC_EVENT_POST_STOP_WORLD = GC_EventType.GC_EVENT_POST_STOP_WORLD;
	alias GC_EVENT_PRE_START_WORLD = GC_EventType.GC_EVENT_PRE_START_WORLD;
	alias GC_EVENT_POST_START_WORLD = GC_EventType.GC_EVENT_POST_START_WORLD;
	alias GC_EVENT_THREAD_SUSPENDED = GC_EventType.GC_EVENT_THREAD_SUSPENDED;
	alias GC_EVENT_THREAD_UNSUSPENDED = GC_EventType.GC_EVENT_THREAD_UNSUSPENDED;
	alias GC_on_collection_event_proc = void function(GC_EventType);
	extern void GC_set_on_collection_event(void function(GC_EventType));
	extern void function(GC_EventType) GC_get_on_collection_event();
	extern __gshared int GC_find_leak;
	extern void GC_set_find_leak(int);
	extern int GC_get_find_leak();
	extern __gshared int GC_all_interior_pointers;
	extern void GC_set_all_interior_pointers(int);
	extern int GC_get_all_interior_pointers();
	extern __gshared int GC_finalize_on_demand;
	extern void GC_set_finalize_on_demand(int);
	extern int GC_get_finalize_on_demand();
	extern __gshared int GC_java_finalization;
	extern void GC_set_java_finalization(int);
	extern int GC_get_java_finalization();
	alias GC_finalizer_notifier_proc = void function();
	extern __gshared void function() GC_finalizer_notifier;
	extern void GC_set_finalizer_notifier(void function());
	extern void function() GC_get_finalizer_notifier();
	alias GC_valid_ptr_print_proc_t = void function(void*);
	alias GC_same_obj_print_proc_t = void function(void*, void*);
	extern __gshared void function(void*, void*) GC_same_obj_print_proc;
	extern __gshared void function(void*) GC_is_valid_displacement_print_proc;
	extern __gshared void function(void*) GC_is_visible_print_proc;
	extern void GC_set_same_obj_print_proc(void function(void*, void*));
	extern void function(void*, void*) GC_get_same_obj_print_proc();
	extern void GC_set_is_valid_displacement_print_proc(void function(void*));
	extern void function(void*) GC_get_is_valid_displacement_print_proc();
	extern void GC_set_is_visible_print_proc(void function(void*));
	extern void function(void*) GC_get_is_visible_print_proc();
	extern __gshared int GC_dont_gc;
	extern __gshared int GC_dont_expand;
	extern void GC_set_dont_expand(int);
	extern int GC_get_dont_expand();
	extern __gshared int GC_use_entire_heap;
	extern __gshared int GC_full_freq;
	extern void GC_set_full_freq(int);
	extern int GC_get_full_freq();
	extern __gshared ulong GC_non_gc_bytes;
	extern void GC_set_non_gc_bytes(ulong);
	extern ulong GC_get_non_gc_bytes();
	extern __gshared int GC_no_dls;
	extern void GC_set_no_dls(int);
	extern int GC_get_no_dls();
	extern __gshared ulong GC_free_space_divisor;
	extern void GC_set_free_space_divisor(ulong);
	extern ulong GC_get_free_space_divisor();
	extern __gshared ulong GC_max_retries;
	extern void GC_set_max_retries(ulong);
	extern ulong GC_get_max_retries();
	extern __gshared char* GC_stackbottom;
	extern __gshared int GC_dont_precollect;
	extern void GC_set_dont_precollect(int);
	extern int GC_get_dont_precollect();
	extern __gshared ulong GC_time_limit;
	extern void GC_set_time_limit(ulong);
	extern ulong GC_get_time_limit();
	struct GC_timeval_s
	{
		ulong tv_ms = void;
		ulong tv_nsec = void;
	}
	extern void GC_set_time_limit_tv(GC_timeval_s);
	extern GC_timeval_s GC_get_time_limit_tv();
	extern void GC_set_allocd_bytes_per_finalizer(ulong);
	extern ulong GC_get_allocd_bytes_per_finalizer();
	extern void GC_start_performance_measurement();
	extern ulong GC_get_full_gc_total_time();
	extern ulong GC_get_stopped_mark_total_time();
	extern void GC_set_pages_executable(int);
	extern int GC_get_pages_executable();
	extern void GC_set_min_bytes_allocd(ulong);
	extern ulong GC_get_min_bytes_allocd();
	extern void GC_set_rate(int);
	extern int GC_get_rate();
	extern void GC_set_max_prior_attempts(int);
	extern int GC_get_max_prior_attempts();
	extern void GC_set_disable_automatic_collection(int);
	extern int GC_get_disable_automatic_collection();
	extern void GC_set_handle_fork(int);
	extern void GC_atfork_prepare();
	extern void GC_atfork_parent();
	extern void GC_atfork_child();
	extern void GC_init();
	extern int GC_is_init_called();
	extern void GC_deinit();
	extern void* GC_malloc(ulong);
	extern void* GC_malloc_atomic(ulong);
	extern char* GC_strdup(const(char)*);
	extern char* GC_strndup(const(char)*, ulong);
	extern void* GC_malloc_uncollectable(ulong);
	extern void* GC_malloc_stubborn(ulong);
	extern void* GC_memalign(ulong, ulong);
	extern int GC_posix_memalign(void**, ulong, ulong);
	extern void* GC_valloc(ulong);
	extern void* GC_pvalloc(ulong);
	extern void GC_free(void*);
	extern void GC_free_profiler_hook(void*);
	extern void GC_change_stubborn(const(void)*);
	extern void GC_end_stubborn_change(const(void)*);
	extern void* GC_base(void*);
	extern int GC_is_heap_ptr(const(void)*);
	extern ulong GC_size(const(void)*);
	extern void* GC_realloc(void*, ulong);
	extern int GC_expand_hp(ulong);
	extern void GC_set_max_heap_size(ulong);
	extern void GC_exclude_static_roots(void*, void*);
	extern void GC_clear_exclusion_table();
	extern void GC_clear_roots();
	extern void GC_add_roots(void*, void*);
	extern void GC_remove_roots(void*, void*);
	extern void GC_register_displacement(ulong);
	extern void GC_debug_register_displacement(ulong);
	extern void GC_gcollect();
	extern void GC_gcollect_and_unmap();
	alias GC_stop_func = int function();
	extern int GC_try_to_collect(int function());
	extern void GC_set_stop_func(int function());
	extern int function() GC_get_stop_func();
	extern ulong GC_get_heap_size();
	extern ulong GC_get_free_bytes();
	extern ulong GC_get_unmapped_bytes();
	extern ulong GC_get_bytes_since_gc();
	extern ulong GC_get_expl_freed_bytes_since_gc();
	extern ulong GC_get_total_bytes();
	extern ulong GC_get_obtained_from_os_bytes();
	extern void GC_get_heap_usage_safe(ulong*, ulong*, ulong*, ulong*, ulong*);
	struct GC_prof_stats_s
	{
		ulong heapsize_full = void;
		ulong free_bytes_full = void;
		ulong unmapped_bytes = void;
		ulong bytes_allocd_since_gc = void;
		ulong allocd_bytes_before_gc = void;
		ulong non_gc_bytes = void;
		ulong gc_no = void;
		ulong markers_m1 = void;
		ulong bytes_reclaimed_since_gc = void;
		ulong reclaimed_bytes_before_gc = void;
		ulong expl_freed_bytes_since_gc = void;
		ulong obtained_from_os_bytes = void;
	}
	extern ulong GC_get_prof_stats(GC_prof_stats_s*, ulong);
	extern ulong GC_get_size_map_at(int i);
	extern ulong GC_get_memory_use();
	extern void GC_disable();
	extern int GC_is_disabled();
	extern void GC_enable();
	extern void GC_set_manual_vdb_allowed(int);
	extern int GC_get_manual_vdb_allowed();
	extern uint GC_get_supported_vdbs();
	extern void GC_enable_incremental();
	extern int GC_is_incremental_mode();
	extern uint GC_get_actual_vdb();
	extern int GC_incremental_protection_needs();
	extern void GC_start_incremental_collection();
	extern int GC_collect_a_little();
	extern void* GC_malloc_ignore_off_page(ulong);
	extern void* GC_malloc_atomic_ignore_off_page(ulong);
	extern void* GC_malloc_atomic_uncollectable(ulong);
	extern void* GC_debug_malloc_atomic_uncollectable(ulong, const(char)* s, int i);
	extern void* GC_debug_malloc(ulong, const(char)* s, int i);
	extern void* GC_debug_malloc_atomic(ulong, const(char)* s, int i);
	extern char* GC_debug_strdup(const(char)*, const(char)* s, int i);
	extern char* GC_debug_strndup(const(char)*, ulong, const(char)* s, int i);
	extern void* GC_debug_malloc_uncollectable(ulong, const(char)* s, int i);
	extern void* GC_debug_malloc_stubborn(ulong, const(char)* s, int i);
	extern void* GC_debug_malloc_ignore_off_page(ulong, const(char)* s, int i);
	extern void* GC_debug_malloc_atomic_ignore_off_page(ulong, const(char)* s, int i);
	extern void GC_debug_free(void*);
	extern void* GC_debug_realloc(void*, ulong, const(char)* s, int i);
	extern void GC_debug_change_stubborn(const(void)*);
	extern void GC_debug_end_stubborn_change(const(void)*);
	extern void* GC_debug_malloc_replacement(ulong);
	extern void* GC_debug_realloc_replacement(void*, ulong);
	alias GC_finalization_proc = void function(void*, void*);
	extern void GC_register_finalizer(void*, void function(void*, void*), void*, void function(void*, void*)*, void**);
	extern void GC_debug_register_finalizer(void*, void function(void*, void*), void*, void function(void*, void*)*, void**);
	extern void GC_register_finalizer_ignore_self(void*, void function(void*, void*), void*, void function(void*, void*)*, void**);
	extern void GC_debug_register_finalizer_ignore_self(void*, void function(void*, void*), void*, void function(void*, void*)*, void**);
	extern void GC_register_finalizer_no_order(void*, void function(void*, void*), void*, void function(void*, void*)*, void**);
	extern void GC_debug_register_finalizer_no_order(void*, void function(void*, void*), void*, void function(void*, void*)*, void**);
	extern void GC_register_finalizer_unreachable(void*, void function(void*, void*), void*, void function(void*, void*)*, void**);
	extern void GC_debug_register_finalizer_unreachable(void*, void function(void*, void*), void*, void function(void*, void*)*, void**);
	extern int GC_register_disappearing_link(void**);
	extern int GC_general_register_disappearing_link(void**, const(void)*);
	extern int GC_move_disappearing_link(void**, void**);
	extern int GC_unregister_disappearing_link(void**);
	extern int GC_register_long_link(void**, const(void)*);
	extern int GC_move_long_link(void**, void**);
	extern int GC_unregister_long_link(void**);
	enum GC_ToggleRefStatus
	{
		GC_TOGGLE_REF_DROP,
		GC_TOGGLE_REF_STRONG,
		GC_TOGGLE_REF_WEAK,
	}
	alias GC_TOGGLE_REF_DROP = GC_ToggleRefStatus.GC_TOGGLE_REF_DROP;
	alias GC_TOGGLE_REF_STRONG = GC_ToggleRefStatus.GC_TOGGLE_REF_STRONG;
	alias GC_TOGGLE_REF_WEAK = GC_ToggleRefStatus.GC_TOGGLE_REF_WEAK;
	alias GC_toggleref_func = GC_ToggleRefStatus function(void*);
	extern void GC_set_toggleref_func(GC_ToggleRefStatus function(void*));
	extern GC_ToggleRefStatus function(void*) GC_get_toggleref_func();
	extern int GC_toggleref_add(void*, int);
	extern int GC_debug_toggleref_add(void*, int);
	alias GC_await_finalize_proc = void function(void*);
	extern void GC_set_await_finalize_proc(void function(void*));
	extern void function(void*) GC_get_await_finalize_proc();
	extern int GC_should_invoke_finalizers();
	extern void GC_set_interrupt_finalizers(uint);
	extern uint GC_get_interrupt_finalizers();
	extern int GC_invoke_finalizers();
	extern void GC_noop1(ulong);
	alias GC_warn_proc = void function(char*, ulong);
	extern void GC_set_warn_proc(void function(char*, ulong));
	extern void function(char*, ulong) GC_get_warn_proc();
	extern void GC_ignore_warn_proc(char*, ulong);
	extern void GC_set_log_fd(int);
	alias GC_abort_func = void function(const(char)*);
	extern void GC_set_abort_func(void function(const(char)*));
	extern void function(const(char)*) GC_get_abort_func();
	extern void GC_abort_on_oom();
	alias GC_hidden_pointer = ulong;
	alias GC_fn_type = void* function(void*);
	extern void* GC_call_with_alloc_lock(void* function(void*), void*);
	struct GC_stack_base
	{
		void* mem_base = void;
	}
	alias GC_stack_base_func = void* function(GC_stack_base*, void*);
	extern void* GC_call_with_stack_base(void* function(GC_stack_base*, void*), void*);
	extern void GC_start_mark_threads();
	extern void* GC_do_blocking(void* function(void*), void*);
	extern void* GC_call_with_gc_active(void* function(void*), void*);
	extern int GC_get_stack_base(GC_stack_base*);
	extern void* GC_get_my_stackbottom(GC_stack_base*);
	extern void GC_set_stackbottom(void*, const GC_stack_base*);
	extern void* GC_pre_incr(void**, long);
	extern void* GC_post_incr(void**, long);
	extern void* GC_same_obj(void*, void*);
	extern void* GC_is_visible(void*);
	extern void* GC_is_valid_displacement(void*);
	extern void GC_dump();
	extern void GC_dump_named(const(char)*);
	extern void GC_dump_regions();
	extern void GC_dump_finalization();
	extern void GC_ptr_store_and_dirty(void*, const(void)*);
	extern void GC_debug_ptr_store_and_dirty(void*, const(void)*);
	extern void* GC_malloc_many(ulong);
	alias GC_has_static_roots_func = int function(const(char)*, void*, ulong);
	extern void GC_register_has_static_roots_callback(int function(const(char)*, void*, ulong));
	extern void GC_set_force_unmap_on_gcollect(int);
	extern int GC_get_force_unmap_on_gcollect();
	extern void GC_win32_free_heap();
	alias GC_bitmap = ulong*;
	alias GC_descr = ulong;
	extern ulong GC_make_descriptor(const(ulong)*, ulong);
	extern void* GC_malloc_explicitly_typed(ulong, ulong);
	extern void* GC_malloc_explicitly_typed_ignore_off_page(ulong, ulong);
	extern void* GC_calloc_explicitly_typed(ulong, ulong, ulong);
	struct GC_calloc_typed_descr_s
	{
		ulong[8] opaque = void;
	}
	extern int GC_calloc_prepare_explicitly_typed(GC_calloc_typed_descr_s*, ulong, ulong, ulong, ulong);
	extern void* GC_calloc_do_explicitly_typed(const GC_calloc_typed_descr_s*, ulong);
	auto GC_GNUC_PREREQ(__MP19, __MP20)(__MP19 major, __MP20 minor)
	{
		return (__GNUC__ << 8) + __GNUC_MINOR__ >= (major << 8) + minor;
	}
	auto GC_MALLOC_STUBBORN(__MP103)(__MP103 sz)
	{
		return GC_MALLOC(sz);
	}
	auto GC_NEW_STUBBORN(__MP104)(__MP104 t)
	{
		return GC_NEW(t);
	}
	auto GC_CHANGE_STUBBORN(__MP105)(__MP105 p)
	{
		return GC_change_stubborn(p);
	}
	enum int GC_VDB_NONE = 0;
	enum int GC_VDB_MPROTECT = 1;
	enum int GC_VDB_MANUAL = 2;
	enum int GC_VDB_DEFAULT = 4;
	enum int GC_VDB_GWW = 8;
	enum int GC_VDB_PCR = 16;
	enum int GC_VDB_PROC = 32;
	enum int GC_VDB_SOFT = 64;
	enum int GC_PROTECTS_POINTER_HEAP = 1;
	enum int GC_PROTECTS_PTRFREE_HEAP = 2;
	enum int GC_PROTECTS_STATIC_DATA = 4;
	enum int GC_PROTECTS_STACK = 8;
	enum int GC_PROTECTS_NONE = 0;
	auto GC_GENERAL_REGISTER_DISAPPEARING_LINK_SAFE(__MP106, __MP107)(__MP106 link, __MP107 obj)
	{
		return GC_general_register_disappearing_link(link, GC_base(cast(void*)cast(ulong)obj));
	}
	auto GC_REGISTER_LONG_LINK_SAFE(__MP108, __MP109)(__MP108 link, __MP109 obj)
	{
		return GC_register_long_link(link, GC_base(cast(void*)cast(ulong)obj));
	}
	auto GC_MALLOC(__MP110)(__MP110 sz)
	{
		return GC_malloc(sz);
	}
	auto GC_REALLOC(__MP111, __MP112)(__MP111 old, __MP112 sz)
	{
		return GC_realloc(old, sz);
	}
	auto GC_MALLOC_ATOMIC(__MP113)(__MP113 sz)
	{
		return GC_malloc_atomic(sz);
	}
	auto GC_STRDUP(__MP114)(__MP114 s)
	{
		return GC_strdup(s);
	}
	auto GC_STRNDUP(__MP115, __MP116)(__MP115 s, __MP116 sz)
	{
		return GC_strndup(s, sz);
	}
	auto GC_MALLOC_ATOMIC_UNCOLLECTABLE(__MP117)(__MP117 sz)
	{
		return GC_malloc_atomic_uncollectable(sz);
	}
	auto GC_MALLOC_UNCOLLECTABLE(__MP118)(__MP118 sz)
	{
		return GC_malloc_uncollectable(sz);
	}
	auto GC_MALLOC_IGNORE_OFF_PAGE(__MP119)(__MP119 sz)
	{
		return GC_malloc_ignore_off_page(sz);
	}
	auto GC_MALLOC_ATOMIC_IGNORE_OFF_PAGE(__MP120)(__MP120 sz)
	{
		return GC_malloc_atomic_ignore_off_page(sz);
	}
	auto GC_FREE(__MP121)(__MP121 p)
	{
		return GC_free(p);
	}
	auto GC_REGISTER_FINALIZER(__MP122, __MP123, __MP124, __MP125, __MP126)(__MP122 p, __MP123 f, __MP124 d, __MP125 of, __MP126 od)
	{
		return GC_register_finalizer(p, f, d, of, od);
	}
	auto GC_REGISTER_FINALIZER_IGNORE_SELF(__MP127, __MP128, __MP129, __MP130, __MP131)(__MP127 p, __MP128 f, __MP129 d, __MP130 of, __MP131 od)
	{
		return GC_register_finalizer_ignore_self(p, f, d, of, od);
	}
	auto GC_REGISTER_FINALIZER_NO_ORDER(__MP132, __MP133, __MP134, __MP135, __MP136)(__MP132 p, __MP133 f, __MP134 d, __MP135 of, __MP136 od)
	{
		return GC_register_finalizer_no_order(p, f, d, of, od);
	}
	auto GC_REGISTER_FINALIZER_UNREACHABLE(__MP137, __MP138, __MP139, __MP140, __MP141)(__MP137 p, __MP138 f, __MP139 d, __MP140 of, __MP141 od)
	{
		return GC_register_finalizer_unreachable(p, f, d, of, od);
	}
	auto GC_TOGGLEREF_ADD(__MP142, __MP143)(__MP142 p, __MP143 is_strong)
	{
		return GC_toggleref_add(p, is_strong);
	}
	auto GC_END_STUBBORN_CHANGE(__MP144)(__MP144 p)
	{
		return GC_end_stubborn_change(p);
	}
	auto GC_PTR_STORE_AND_DIRTY(__MP145, __MP146)(__MP145 p, __MP146 q)
	{
		return GC_ptr_store_and_dirty(p, q);
	}
	auto GC_GENERAL_REGISTER_DISAPPEARING_LINK(__MP147, __MP148)(__MP147 link, __MP148 obj)
	{
		return GC_general_register_disappearing_link(link, obj);
	}
	auto GC_REGISTER_LONG_LINK(__MP149, __MP150)(__MP149 link, __MP150 obj)
	{
		return GC_register_long_link(link, obj);
	}
	auto GC_REGISTER_DISPLACEMENT(__MP151)(__MP151 n)
	{
		return GC_register_displacement(n);
	}
	enum int GC_NO_MEMORY = 2;
	auto GC_HIDE_POINTER(__MP156)(__MP156 p)
	{
		return ~cast(ulong)p;
	}
	auto GC_REVEAL_POINTER(__MP157)(__MP157 p)
	{
		return cast(void*)GC_HIDE_POINTER(p);
	}
	auto GC_HIDE_NZ_POINTER(__MP158)(__MP158 p)
	{
		return cast(ulong)-cast(long)p;
	}
	auto GC_REVEAL_NZ_POINTER(__MP159)(__MP159 p)
	{
		return cast(void*)GC_HIDE_NZ_POINTER(p);
	}
	auto GC_alloc_lock()()
	{
		return cast(void)0;
	}
	auto GC_alloc_unlock()()
	{
		return cast(void)0;
	}
	auto GC_call_with_reader_lock(__MP160, __MP161, __MP162)(__MP160 fn, __MP161 cd, __MP162 r)
	{
		return cast(void)r , fn(cd);
	}
	enum int GC_SUCCESS = 0;
	enum int GC_DUPLICATE = 1;
	enum int GC_NO_THREADS = 2;
	enum int GC_UNIMPLEMENTED = 3;
	enum int GC_NOT_FOUND = 4;
	auto GC_PTR_ADD(__MP163, __MP164)(__MP163 x, __MP164 n)
	{
		return x + n;
	}
	auto GC_PRE_INCR(__MP165, __MP166)(__MP165 x, __MP166 n)
	{
		return x += n;
	}
	auto GC_POST_INCR(__MP167)(__MP167 x)
	{
		return x++;
	}
	auto GC_POST_DECR(__MP168)(__MP168 x)
	{
		return x--;
	}
	auto GC_PTR_STORE(__MP169, __MP170)(__MP169 p, __MP170 q)
	{
		return *cast(void**)p = cast(void*)q;
	}
	auto GC_NEXT(__MP171)(__MP171 p)
	{
		return *cast(void**)p;
	}
	auto GC_WORDSZ()()
	{
		return 8 * (ulong).sizeof;
	}
	auto GC_get_bit(__MP172, __MP173)(__MP172 bm, __MP173 index)
	{
		return bm[index / GC_WORDSZ] >> index % GC_WORDSZ & 1;
	}
	auto GC_set_bit(__MP174, __MP175)(__MP174 bm, __MP175 index)
	{
		return bm[index / GC_WORDSZ] |= cast(ulong)1 << index % GC_WORDSZ;
	}
	auto GC_WORD_OFFSET(__MP176, __MP177)(__MP176 t, __MP177 f)
	{
		return offsetof(t, f) / (ulong).sizeof;
	}
	auto GC_WORD_LEN(__MP178)(__MP178 t)
	{
		return t.sizeof / (ulong).sizeof;
	}
	auto GC_BITMAP_SIZE(__MP179)(__MP179 t)
	{
		return (GC_WORD_LEN(t) + GC_WORDSZ - 1) / GC_WORDSZ;
	}
	enum int GC_CALLOC_TYPED_DESCR_WORDS = 8;
	auto GC_MALLOC_EXPLICITLY_TYPED(__MP180, __MP181)(__MP180 bytes, __MP181 d)
	{
		return GC_malloc_explicitly_typed(bytes, d);
	}
	auto GC_MALLOC_EXPLICITLY_TYPED_IGNORE_OFF_PAGE(__MP182, __MP183)(__MP182 bytes, __MP183 d)
	{
		return GC_malloc_explicitly_typed_ignore_off_page(bytes, d);
	}
	auto GC_CALLOC_EXPLICITLY_TYPED(__MP184, __MP185, __MP186)(__MP184 n, __MP185 bytes, __MP186 d)
	{
		return GC_calloc_explicitly_typed(n, bytes, d);
	}
	auto alloca(__MP252)(__MP252 size)
	{
		return __builtin_alloca(size);
	}
	auto malloc(__MP257)(__MP257 n)
	{
		return GC_MALLOC(n);
	}
	auto calloc(__MP258, __MP259)(__MP258 m, __MP259 n)
	{
		return GC_MALLOC(m * n);
	}
	auto free(__MP260)(__MP260 p)
	{
		return GC_FREE(p);
	}
	auto realloc(__MP261, __MP262)(__MP261 p, __MP262 n)
	{
		return GC_REALLOC(p, n);
	}
	auto reallocarray(__MP263, __MP264, __MP265)(__MP263 p, __MP264 m, __MP265 n)
	{
		return GC_REALLOC(p, m * n);
	}
	auto strdup(__MP266)(__MP266 s)
	{
		return GC_STRDUP(s);
	}
	auto strndup(__MP267, __MP268)(__MP267 s, __MP268 n)
	{
		return GC_STRNDUP(s, n);
	}
	auto aligned_alloc(__MP269, __MP270)(__MP269 a, __MP270 n)
	{
		return GC_memalign(a, n);
	}
	auto memalign(__MP271, __MP272)(__MP271 a, __MP272 n)
	{
		return GC_memalign(a, n);
	}
	auto posix_memalign(__MP273, __MP274, __MP275)(__MP273 p, __MP274 a, __MP275 n)
	{
		return GC_posix_memalign(p, a, n);
	}
	auto _aligned_malloc(__MP276, __MP277)(__MP276 n, __MP277 a)
	{
		return GC_memalign(a, n);
	}
	auto _aligned_free(__MP278)(__MP278 p)
	{
		return GC_free(p);
	}
	auto valloc(__MP279)(__MP279 n)
	{
		return GC_valloc(n);
	}
	auto pvalloc(__MP280)(__MP280 n)
	{
		return GC_pvalloc(n);
	}
	auto CHECK_LEAKS()()
	{
		return GC_gcollect();
	}
}
