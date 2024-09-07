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
	alias GC_oom_func = void* function(ulong);
	extern __gshared void* function(ulong) GC_oom_fn;
	extern void GC_set_oom_fn(scope void* function(ulong));
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
	extern char* GC_strdup(scope const(char)*);
	extern char* GC_strndup(scope const(char)*, ulong);
	extern void* GC_malloc_uncollectable(ulong);
	extern void* GC_malloc_stubborn(ulong);
	extern void* GC_memalign(ulong, ulong);
	extern int GC_posix_memalign(scope void**, ulong, ulong);
	extern void GC_free(scope void*);
	extern void GC_change_stubborn(scope const(void)*);
	extern void GC_end_stubborn_change(scope const(void)*);
	extern void* GC_base(scope void*);
	extern int GC_is_heap_ptr(scope const(void)*);
	extern ulong GC_size(scope const(void)*);
	extern void* GC_realloc(scope void*, ulong);
	extern int GC_expand_hp(ulong);
	extern void GC_set_max_heap_size(ulong);
	extern void GC_exclude_static_roots(scope void*, scope void*);
	extern void GC_clear_exclusion_table();
	extern void GC_clear_roots();
	extern void GC_add_roots(scope void*, scope void*);
	extern void GC_remove_roots(scope void*, scope void*);
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
	extern void GC_get_heap_usage_safe(scope ulong*, scope ulong*, scope ulong*, scope ulong*, scope ulong*);
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
	extern void GC_enable_incremental();
	extern int GC_is_incremental_mode();
	extern int GC_incremental_protection_needs();
	extern void GC_start_incremental_collection();
	extern int GC_collect_a_little();
	extern void* GC_malloc_ignore_off_page(ulong);
	extern void* GC_malloc_atomic_ignore_off_page(ulong);
	extern void* GC_malloc_atomic_uncollectable(ulong);
	extern void* GC_debug_malloc_atomic_uncollectable(ulong, scope const(char)* s, int i);
	extern void* GC_debug_malloc(ulong, scope const(char)* s, int i);
	extern void* GC_debug_malloc_atomic(ulong, scope const(char)* s, int i);
	extern char* GC_debug_strdup(scope const(char)*, scope const(char)* s, int i);
	extern char* GC_debug_strndup(scope const(char)*, ulong, scope const(char)* s, int i);
	extern void* GC_debug_malloc_uncollectable(ulong, scope const(char)* s, int i);
	extern void* GC_debug_malloc_stubborn(ulong, scope const(char)* s, int i);
	extern void* GC_debug_malloc_ignore_off_page(ulong, scope const(char)* s, int i);
	extern void* GC_debug_malloc_atomic_ignore_off_page(ulong, scope const(char)* s, int i);
	extern void GC_debug_free(scope void*);
	extern void* GC_debug_realloc(scope void*, ulong, scope const(char)* s, int i);
	extern void GC_debug_change_stubborn(scope const(void)*);
	extern void GC_debug_end_stubborn_change(scope const(void)*);
	extern void* GC_debug_malloc_replacement(ulong);
	extern void* GC_debug_realloc_replacement(scope void*, ulong);
	alias GC_finalization_proc = void function(scope void*, scope void*);
	extern void GC_register_finalizer(scope void*, void function(scope void*, scope void*), scope void*, void function(
			scope void*, scope void*)*, scope void**);
	extern void GC_debug_register_finalizer(scope void*, void function(scope void*, scope void*), scope void*, void function(
			scope void*, scope void*)*, scope void**);
	extern void GC_register_finalizer_ignore_self(scope void*, void function(scope void*, scope void*), scope void*, void function(
			void*, scope void*)*, scope void**);
	extern void GC_debug_register_finalizer_ignore_self(scope void*, void function(scope void*, scope void*), scope void*, void function(
			void*, scope void*)*, scope void**);
	extern void GC_register_finalizer_no_order(scope void*, void function(scope void*, scope void*), scope void*, void function(
			scope void*, scope void*)*, scope void**);
	extern void GC_debug_register_finalizer_no_order(scope void*, void function(scope void*, scope void*), scope void*, void function(
			void*, scope void*)*, scope void**);
	extern void GC_register_finalizer_unreachable(scope void*, void function(scope void*, scope void*), scope void*, void function(
			void*, scope void*)*, scope void**);
	extern void GC_debug_register_finalizer_unreachable(scope void*, void function(scope void*, scope void*), scope void*, void function(
			void*, scope void*)*, scope void**);
	extern int GC_register_disappearing_link(scope void**);
	extern int GC_general_register_disappearing_link(scope void**, scope const(void)*);
	extern int GC_move_disappearing_link(scope void**, scope void**);
	extern int GC_unregister_disappearing_link(scope void**);
	extern int GC_register_long_link(scope void**, scope const(void)*);
	extern int GC_move_long_link(scope void**, scope void**);
	extern int GC_unregister_long_link(scope void**);
	enum GC_ToggleRefStatus
	{
		GC_TOGGLE_REF_DROP,
		GC_TOGGLE_REF_STRONG,
		GC_TOGGLE_REF_WEAK,
	}

	alias GC_TOGGLE_REF_DROP = GC_ToggleRefStatus.GC_TOGGLE_REF_DROP;
	alias GC_TOGGLE_REF_STRONG = GC_ToggleRefStatus.GC_TOGGLE_REF_STRONG;
	alias GC_TOGGLE_REF_WEAK = GC_ToggleRefStatus.GC_TOGGLE_REF_WEAK;
	alias GC_toggleref_func = GC_ToggleRefStatus function(scope void*);
	extern void GC_set_toggleref_func(GC_ToggleRefStatus function(scope void*));
	extern GC_ToggleRefStatus function(scope void*) GC_get_toggleref_func();
	extern int GC_toggleref_add(scope void*, int);
	alias GC_await_finalize_proc = void function(scope void*);
	extern void GC_set_await_finalize_proc(void function(scope void*));
	extern void function(scope void*) GC_get_await_finalize_proc();
	extern int GC_should_invoke_finalizers();
	extern int GC_invoke_finalizers();
	alias GC_warn_proc = void function(char*, ulong);
	extern void GC_set_warn_proc(void function(char*, ulong));
	extern void function(char*, ulong) GC_get_warn_proc();
	extern void GC_ignore_warn_proc(char*, ulong);
	extern void GC_set_log_fd(int);
	alias GC_abort_func = void function(scope const(char)*);
	extern void GC_set_abort_func(void function(scope const(char)*));
	extern void function(scope const(char)*) GC_get_abort_func();
	extern void GC_abort_on_oom();
	alias GC_hidden_pointer = ulong;
	alias GC_fn_type = void* function(scope void*);
	extern void* GC_call_with_alloc_lock(scope void* function(scope void*), scope void*);
	struct GC_stack_base
	{
		void* mem_base = void;
	}

	alias GC_stack_base_func = void* function(GC_stack_base*, scope void*);
	extern void* GC_call_with_stack_base(scope void* function(GC_stack_base*, scope void*), scope void*);
	extern void GC_start_mark_threads();
	extern void* GC_do_blocking(scope void* function(scope void*), scope void*);
	extern void* GC_call_with_gc_active(scope void* function(scope void*), scope void*);
	extern int GC_get_stack_base(GC_stack_base*);
	extern void* GC_get_my_stackbottom(GC_stack_base*);
	extern void GC_set_stackbottom(scope void*, const GC_stack_base*);
	extern void* GC_same_obj(scope void*, scope void*);
	extern void* GC_pre_incr(scope void**, long);
	extern void* GC_post_incr(scope void**, long);
	extern void* GC_is_visible(scope void*);
	extern void* GC_is_valid_displacement(scope void*);
	extern void GC_dump();
	extern void GC_dump_named(scope const(char)*);
	extern void GC_dump_regions();
	extern void GC_dump_finalization();
	extern void GC_ptr_store_and_dirty(scope void*, scope const(void)*);
	extern void GC_debug_ptr_store_and_dirty(scope void*, scope const(void)*);
	extern __gshared void function(scope void*, scope void*) GC_same_obj_print_proc;
	extern __gshared void function(scope void*) GC_is_valid_displacement_print_proc;
	extern __gshared void function(scope void*) GC_is_visible_print_proc;
	extern void* GC_malloc_many(ulong);
	alias GC_has_static_roots_func = int function(scope const(char)*, void*, ulong);
	extern void GC_register_has_static_roots_callback(int function(scope const(char)*, scope void*, ulong));
	extern void GC_set_force_unmap_on_gcollect(int);
	extern int GC_get_force_unmap_on_gcollect();
	extern void GC_win32_free_heap();

	enum int GC_TIME_UNLIMITED = 999999;
	auto GC_MALLOC_STUBBORN(__MP101)(__MP101 sz)
	{
		return GC_MALLOC(sz);
	}

	auto GC_NEW_STUBBORN(__MP102)(__MP102 t)
	{
		return GC_NEW(t);
	}

	auto GC_CHANGE_STUBBORN(__MP103)(__MP103 p)
	{
		return GC_change_stubborn(p);
	}

	enum int GC_PROTECTS_POINTER_HEAP = 1;
	enum int GC_PROTECTS_PTRFREE_HEAP = 2;
	enum int GC_PROTECTS_STATIC_DATA = 4;
	enum int GC_PROTECTS_STACK = 8;
	enum int GC_PROTECTS_NONE = 0;
	auto GC_MALLOC(__MP104)(__MP104 sz)
	{
		return GC_malloc(sz);
	}

	auto GC_REALLOC(__MP105, __MP106)(__MP105 old, __MP106 sz)
	{
		return GC_realloc(old, sz);
	}

	auto GC_MALLOC_ATOMIC(__MP107)(__MP107 sz)
	{
		return GC_malloc_atomic(sz);
	}

	auto GC_STRDUP(__MP108)(__MP108 s)
	{
		return GC_strdup(s);
	}

	auto GC_STRNDUP(__MP109, __MP110)(__MP109 s, __MP110 sz)
	{
		return GC_strndup(s, sz);
	}

	auto GC_MALLOC_ATOMIC_UNCOLLECTABLE(__MP111)(__MP111 sz)
	{
		return GC_malloc_atomic_uncollectable(sz);
	}

	auto GC_MALLOC_UNCOLLECTABLE(__MP112)(__MP112 sz)
	{
		return GC_malloc_uncollectable(sz);
	}

	auto GC_MALLOC_IGNORE_OFF_PAGE(__MP113)(__MP113 sz)
	{
		return GC_malloc_ignore_off_page(sz);
	}

	auto GC_MALLOC_ATOMIC_IGNORE_OFF_PAGE(__MP114)(__MP114 sz)
	{
		return GC_malloc_atomic_ignore_off_page(sz);
	}

	auto GC_FREE(__MP115)(__MP115 p)
	{
		return GC_free(p);
	}

	auto GC_REGISTER_FINALIZER(__MP116, __MP117, __MP118, __MP119, __MP120)(__MP116 p, __MP117 f, __MP118 d, __MP119 of, __MP120 od)
	{
		return GC_register_finalizer(p, f, d, of, od);
	}

	auto GC_REGISTER_FINALIZER_IGNORE_SELF(__MP121, __MP122, __MP123, __MP124, __MP125)(
		__MP121 p, __MP122 f, __MP123 d, __MP124 of, __MP125 od)
	{
		return GC_register_finalizer_ignore_self(p, f, d, of, od);
	}

	auto GC_REGISTER_FINALIZER_NO_ORDER(__MP126, __MP127, __MP128, __MP129, __MP130)(
		__MP126 p, __MP127 f, __MP128 d, __MP129 of, __MP130 od)
	{
		return GC_register_finalizer_no_order(p, f, d, of, od);
	}

	auto GC_REGISTER_FINALIZER_UNREACHABLE(__MP131, __MP132, __MP133, __MP134, __MP135)(
		__MP131 p, __MP132 f, __MP133 d, __MP134 of, __MP135 od)
	{
		return GC_register_finalizer_unreachable(p, f, d, of, od);
	}

	auto GC_END_STUBBORN_CHANGE(__MP136)(__MP136 p)
	{
		return GC_end_stubborn_change(p);
	}

	auto GC_PTR_STORE_AND_DIRTY(__MP137, __MP138)(__MP137 p, __MP138 q)
	{
		return GC_ptr_store_and_dirty(p, q);
	}

	auto GC_GENERAL_REGISTER_DISAPPEARING_LINK(__MP139, __MP140)(__MP139 link, __MP140 obj)
	{
		return GC_general_register_disappearing_link(link, obj);
	}

	auto GC_REGISTER_LONG_LINK(__MP141, __MP142)(__MP141 link, __MP142 obj)
	{
		return GC_register_long_link(link, obj);
	}

	auto GC_REGISTER_DISPLACEMENT(__MP143)(__MP143 n)
	{
		return GC_register_displacement(n);
	}

	enum int GC_NO_MEMORY = 2;
	auto GC_HIDE_POINTER(__MP148)(__MP148 p)
	{
		return ~cast(ulong) p;
	}

	auto GC_REVEAL_POINTER(__MP149)(__MP149 p)
	{
		return cast(void*) GC_HIDE_POINTER(p);
	}

	auto GC_alloc_lock()()
	{
		return cast(void) 0;
	}

	auto GC_alloc_unlock()()
	{
		return cast(void) 0;
	}

	enum int GC_SUCCESS = 0;
	enum int GC_DUPLICATE = 1;
	enum int GC_NO_THREADS = 2;
	enum int GC_UNIMPLEMENTED = 3;
	enum int GC_NOT_FOUND = 4;
	auto GC_PTR_ADD(__MP150, __MP151)(__MP150 x, __MP151 n)
	{
		return x + n;
	}

	auto GC_PRE_INCR(__MP152, __MP153)(__MP152 x, __MP153 n)
	{
		return x += n;
	}

	auto GC_POST_INCR(__MP154)(__MP154 x)
	{
		return x++;
	}

	auto GC_POST_DECR(__MP155)(__MP155 x)
	{
		return x--;
	}

	auto GC_PTR_STORE(__MP156, __MP157)(__MP156 p, __MP157 q)
	{
		return *cast(void**) p = cast(void*) q;
	}

	auto GC_NEXT(__MP158)(__MP158 p)
	{
		return *cast(void**) p;
	}
}
