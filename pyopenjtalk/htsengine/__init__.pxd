# distutils: language = c++
from libc.stdio cimport FILE

cdef extern from "HTS_engine.h":
    cdef cppclass _HTS_Engine:
        pass
    ctypedef _HTS_Engine HTS_Engine

    void HTS_Engine_initialize(HTS_Engine * engine)
    char HTS_Engine_load(HTS_Engine * engine, char **voices, size_t num_voices)
    size_t HTS_Engine_get_sampling_frequency(HTS_Engine * engine)
    size_t HTS_Engine_get_fperiod(HTS_Engine * engine)
    void HTS_Engine_refresh(HTS_Engine * engine)
    void HTS_Engine_clear(HTS_Engine * engine)
    const char *HTS_Engine_get_fullcontext_label_format(HTS_Engine * engine)
    char HTS_Engine_synthesize_from_strings(HTS_Engine * engine, char **lines, size_t num_lines)
    char HTS_Engine_synthesize_from_fn(HTS_Engine * engine, const char *fn)
    double HTS_Engine_get_generated_speech(HTS_Engine * engine, size_t index)
    size_t HTS_Engine_get_nsamples(HTS_Engine * engine)

    void HTS_Engine_set_speed(HTS_Engine * engine, double f)
    void HTS_Engine_add_half_tone(HTS_Engine * engine, double f)

    # 追加 https://github.com/r9y9/hts_engine_API/blob/master/src/include/HTS_engine.h
    ctypedef char HTS_Boolean;
    # /* HTS_Engine_set_sampling_frequency: set sampling fraquency */
    void HTS_Engine_set_sampling_frequency(HTS_Engine * engine, size_t i)

    # /* HTS_Engine_set_fperiod: set frame period */
    void HTS_Engine_set_fperiod(HTS_Engine * engine, size_t i)

    # /* HTS_Engine_set_volume: set volume in db */
    void HTS_Engine_set_volume(HTS_Engine * engine, double f)

    # /* HTS_Engine_get_volume: get volume in db */
    double HTS_Engine_get_volume(HTS_Engine * engine)

    # /* HTS_Egnine_set_msd_threshold: set MSD threshold */
    void HTS_Engine_set_msd_threshold(HTS_Engine * engine, size_t stream_index, double f)

    # /* HTS_Engine_get_msd_threshold: get MSD threshold */
    double HTS_Engine_get_msd_threshold(HTS_Engine * engine, size_t stream_index)

    # /* HTS_Engine_set_gv_weight: set GV weight */
    void HTS_Engine_set_gv_weight(HTS_Engine * engine, size_t stream_index, double f)

    # /* HTS_Engine_get_gv_weight: get GV weight */
    double HTS_Engine_get_gv_weight(HTS_Engine * engine, size_t stream_index)

    # /* HTS_Engine_set_audio_buff_size: set audio buffer size */
    void HTS_Engine_set_audio_buff_size(HTS_Engine * engine, size_t i)

    # /* HTS_Engine_get_audio_buff_size: get audio buffer size */
    size_t HTS_Engine_get_audio_buff_size(HTS_Engine * engine)

    # /* HTS_Engine_set_stop_flag: set stop flag */
    void HTS_Engine_set_stop_flag(HTS_Engine * engine, HTS_Boolean b)

    # /* HTS_Engine_get_stop_flag: get stop flag */
    HTS_Boolean HTS_Engine_get_stop_flag(HTS_Engine * engine)

    # /* HTS_Engine_set_phoneme_alignment_flag: set flag for using phoneme alignment in label */
    void HTS_Engine_set_phoneme_alignment_flag(HTS_Engine * engine, HTS_Boolean b)

    # /* HTS_Engine_set_alpha: set alpha */
    void HTS_Engine_set_alpha(HTS_Engine * engine, double f)

    # /* HTS_Engine_get_alpha: get alpha */
    double HTS_Engine_get_alpha(HTS_Engine * engine)

    # /* HTS_Engine_set_beta: set beta */
    void HTS_Engine_set_beta(HTS_Engine * engine, double f)

    # /* HTS_Engine_get_beta: get beta */
    double HTS_Engine_get_beta(HTS_Engine * engine)

    # /* HTS_Engine_set_duration_interpolation_weight: set interpolation weight for duration */
    void HTS_Engine_set_duration_interpolation_weight(HTS_Engine * engine, size_t voice_index, double f)

    # /* HTS_Engine_get_duration_interpolation_weight: get interpolation weight for duration */
    double HTS_Engine_get_duration_interpolation_weight(HTS_Engine * engine, size_t voice_index)

    # /* HTS_Engine_set_parameter_interpolation_weight: set interpolation weight for parameter */
    void HTS_Engine_set_parameter_interpolation_weight(HTS_Engine * engine, size_t voice_index, size_t stream_index, double f)

    # /* HTS_Engine_get_parameter_interpolation_weight: get interpolation weight for parameter */
    double HTS_Engine_get_parameter_interpolation_weight(HTS_Engine * engine, size_t voice_index, size_t stream_index)

    # /* HTS_Engine_set_gv_interpolation_weight: set interpolation weight for GV */
    void HTS_Engine_set_gv_interpolation_weight(HTS_Engine * engine, size_t voice_index, size_t stream_index, double f)

    # /* HTS_Engine_get_gv_interpolation_weight: get interpolation weight for GV */
    double HTS_Engine_get_gv_interpolation_weight(HTS_Engine * engine, size_t voice_index, size_t stream_index)

    # /* HTS_Engine_get_total_state: get total number of state */
    size_t HTS_Engine_get_total_state(HTS_Engine * engine)

    # /* HTS_Engine_set_state_mean: set mean value of state */
    void HTS_Engine_set_state_mean(HTS_Engine * engine, size_t stream_index, size_t state_index, size_t vector_index, double f)

    # /* HTS_Engine_get_state_mean: get mean value of state */
    double HTS_Engine_get_state_mean(HTS_Engine * engine, size_t stream_index, size_t state_index, size_t vector_index)

    # /* HTS_Engine_get_state_duration: get state duration */
    size_t HTS_Engine_get_state_duration(HTS_Engine * engine, size_t state_index)

    # /* HTS_Engine_get_nvoices: get number of voices */
    size_t HTS_Engine_get_nvoices(HTS_Engine * engine)

    # /* HTS_Engine_get_nstream: get number of stream */
    size_t HTS_Engine_get_nstream(HTS_Engine * engine)

    # /* HTS_Engine_get_nstate: get number of state */
    size_t HTS_Engine_get_nstate(HTS_Engine * engine)

    # /* HTS_Engine_get_fullcontext_label_version: get full context label version */
    const char *HTS_Engine_get_fullcontext_label_version(HTS_Engine * engine)

    # /* HTS_Engine_get_total_frame: get total number of frame */
    size_t HTS_Engine_get_total_frame(HTS_Engine * engine)

    # /* HTS_Engine_get_generated_parameter: output generated parameter */
    double HTS_Engine_get_generated_parameter(HTS_Engine * engine, size_t stream_index, size_t frame_index, size_t vector_index)

    # /* HTS_Engine_generate_state_sequence_from_fn: generate state sequence from file name (1st synthesis step) */
    HTS_Boolean HTS_Engine_generate_state_sequence_from_fn(HTS_Engine * engine, const char *fn)

    # /* HTS_Engine_generate_state_sequence_from_strings: generate state sequence from string list (1st synthesis step) */
    HTS_Boolean HTS_Engine_generate_state_sequence_from_strings(HTS_Engine * engine, char **lines, size_t num_lines)

    # /* HTS_Engine_generate_parameter_sequence: generate parameter sequence (2nd synthesis step) */
    HTS_Boolean HTS_Engine_generate_parameter_sequence(HTS_Engine * engine)

    # /* HTS_Engine_generate_sample_sequence: generate sample sequence (3rd synthesis step) */
    HTS_Boolean HTS_Engine_generate_sample_sequence(HTS_Engine * engine)

    # /* HTS_Engine_save_information: save trace information */
    void HTS_Engine_save_information(HTS_Engine * engine, FILE * fp)
#    void HTS_Engine_save_information(HTS_Engine * engine, FILE_PTR fp)

    # /* HTS_Engine_save_label: save label with time */
    void HTS_Engine_save_label(HTS_Engine * engine, FILE * fp)
#    void HTS_Engine_save_label(HTS_Engine * engine, FILE_PTR fp)

    # /* HTS_Engine_save_generated_parameter: save generated parameter */
    void HTS_Engine_save_generated_parameter(HTS_Engine * engine, size_t stream_index, FILE * fp)
#    void HTS_Engine_save_generated_parameter(HTS_Engine * engine, size_t stream_index, FILE_PTR fp)

    # /* HTS_Engine_save_generated_speech: save generated speech */
    void HTS_Engine_save_generated_speech(HTS_Engine * engine, FILE * fp)
#    void HTS_Engine_save_generated_speech(HTS_Engine * engine, FILE_PTR fp)

    # /* HTS_Engine_save_riff: save RIFF format file */
    void HTS_Engine_save_riff(HTS_Engine * engine, FILE * fp)
#    void HTS_Engine_save_riff(HTS_Engine * engine, FILE_PTR fp)

